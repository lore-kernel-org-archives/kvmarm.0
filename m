Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CBE31282F0E
	for <kvmarm@lists.linux.dev>; Wed,  6 May 2026 10:51:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778064673; cv=none; b=DG3ae3TBxAU/5hijltE4kzVnVq41sTKsOHFubmq6cyAQEAdDSL0XwOYaj7P6o/vb6Mt4nwb7FW7iiQvqiF3QIlXAc8dv24bQxJZqcrPn4/VWCVFlExIs3WBaJ9LClA9+DFfmXT8VlqgsoAhybQCOorWzyTzJ1pV6ioHP27JYwlc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778064673; c=relaxed/simple;
	bh=mLq4TYQ+p660O5valtgnJ3LrPuMxPXfWPFxW8jxq8TM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=oBbf4Lpe+/sjGabHIHzLOyN9PKvbadRK6v8XACXzSVVrWtkUocqj3mtIea9G3pe/42RT0fhwIZNeAj/u6WwuVIzBCnl/ntin7FZtfMdQqMQ1JP8xGpSXQIwJprtXZ4L7wihyUJGpobzPOQd0M1W0kAPezPyHY3ihPargWwe9mEI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=HhbmJIyP; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="HhbmJIyP"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id C25DF3319;
	Wed,  6 May 2026 03:51:04 -0700 (PDT)
Received: from raptor (usa-sjc-mx-foss1.foss.arm.com [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 8425B3F836;
	Wed,  6 May 2026 03:51:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1778064670; bh=mLq4TYQ+p660O5valtgnJ3LrPuMxPXfWPFxW8jxq8TM=;
	h=From:To:Cc:Subject:Date:From;
	b=HhbmJIyP9sJImfrgGpIg9HwAvlfR0pBsXr5v0luiixEE4kRlqA3UwFXBPEXZcJhfF
	 Zj9jsusPv3Ts5AACq5YHPuxlUPuCA6HmU6NsRqFWERiU2mpZw5oUQZhEcLRx1xSiYC
	 p7+CE3QvEgODB1jgUMQuj4OCtScayA3nY18WMotQ=
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: maz@kernel.org,
	oupton@kernel.org,
	joey.gouly@arm.com,
	suzuki.poulose@arm.com,
	yuzenghui@huawei.com,
	linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev
Cc: tabba@google.com,
	David.Hildenbrand@arm.com
Subject: [RFC PATCH] KVM: arm64: Align KVM_EXIT_MEMORY_FAULT error codes with documentation
Date: Wed,  6 May 2026 11:50:53 +0100
Message-ID: <20260506105053.107404-1-alexandru.elisei@arm.com>
X-Mailer: git-send-email 2.54.0
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The documentation for KVM_EXIT_MEMORY_FAULT states:

'Note!  KVM_EXIT_MEMORY_FAULT is unique among all KVM exit reasons in that
it accompanies a return code of '-1', not '0'!  errno will always be set to
EFAULT or EHWPOISON when KVM exits with KVM_EXIT_MEMORY_FAULT, userspace
should assume kvm_run.exit_reason is stale/undefined for all other error
numbers'.

where a return code of '-1' is special because according to man 2 ioctl:

'On error, -1 is returned, and errno is set to indicate the error'.

Putting the two together means that the ioctl KVM_RUN must 1) complete with
an error and 2) that error must must be either EFAULT or EHWPOISON for
userspace to detect a KVM_EXIT_MEMORY_FAULT VCPU exit.

On a kvm_gmem_get_pfn() error, gmem_abort() prepares the
KVM_EXIT_MEMORY_FAULT exit_reason and propagates the error back to
userspace. kvm_gmem_get_pfn() does not massage the error code, and if the
error is not -EFAULT or -EHWPOISON, userspace implementing the ABI fails to
detect the memory fault exit.

Things get more complicated with kvm_handle_vncr_abort().
kvm_translate_vncr(), similar to gmem_abort(), prepares the VCPU to exit
with KVM_EXIT_MEMORY_FAULT and propagates the error code from
kvm_gmem_get_pfn(). Then kvm_handle_vncr_abort() does a number of things
based on this specific error code:

- If it's -EAGAIN, KVM resumes the guest. Note that KVM, when handling a
  *host* fault on a guest_memfd backed VMA, retries the fault handling if
  kvm_gmem_get_pfn() returns -EAGAIN.
- If it's -ENOMEM, -EFAULT, -EIO or -EHWPOISON, it returns to userspace
  with 0 (success), meaning that, according to the documentation, userspace
  will not detect the memory fault exit.
- If it's -EINVAL, -ENOENT, -EACCESS, KVM injects a synchronous exception
  back to the guest.
- If it's -EPERM, KVM injects a permission fault.
- If the error code is something else, KVM resumes the guest.

Bring a measure of order to all of this by implementing the documented
behaviour. -EAGAIN is treated as an error, similar to the
__kvm_faultin_pfn() behaviour for an anonymous VMA.

Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
---

This has the potential to break userspace, hence the RFC tag.

I went back and forth on the fix. I cannot test any of this and I have no
context around the usage of guest_memfd. In the end I settled on strictly
implementing the documented behaviour.

Really not sure what userspace is supposed to do to fixup the fault if
kvm_gmem_get_pfn() returns -EAGAIN either.

Someone with more knowledge please chime in!

 arch/arm64/kvm/mmu.c    |  8 +++++++-
 arch/arm64/kvm/nested.c | 24 +++++++++++++-----------
 2 files changed, 20 insertions(+), 12 deletions(-)

diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index d089c107d9b7..ea6c96818fc6 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -1610,7 +1610,13 @@ static int gmem_abort(const struct kvm_s2_fault_desc *s2fd)
 	if (ret) {
 		kvm_prepare_memory_fault_exit(s2fd->vcpu, s2fd->fault_ipa, PAGE_SIZE,
 					      write_fault, exec_fault, false);
-		return ret;
+		switch (ret) {
+		case -EFAULT:
+		case -EHWPOISON:
+			return ret;
+		default:
+			return -EFAULT;
+		}
 	}
 
 	if (!(s2fd->memslot->flags & KVM_MEM_READONLY))
diff --git a/arch/arm64/kvm/nested.c b/arch/arm64/kvm/nested.c
index 883b6c1008fb..ef426c94daff 100644
--- a/arch/arm64/kvm/nested.c
+++ b/arch/arm64/kvm/nested.c
@@ -1320,8 +1320,14 @@ static int kvm_translate_vncr(struct kvm_vcpu *vcpu, bool *is_gmem)
 		ret = kvm_gmem_get_pfn(vcpu->kvm, memslot, gfn, &pfn, &page, NULL);
 		if (ret) {
 			kvm_prepare_memory_fault_exit(vcpu, vt->wr.pa, PAGE_SIZE,
-					      write_fault, false, false);
-			return ret;
+						      write_fault, false, false);
+			switch (ret) {
+			case -EFAULT:
+			case -EHWPOISON:
+				return ret;
+			default:
+				return -EFAULT;
+			}
 		}
 	}
 
@@ -1401,23 +1407,19 @@ int kvm_handle_vncr_abort(struct kvm_vcpu *vcpu)
 
 		switch (ret) {
 		case -EAGAIN:
+		case -ENOMEM:
 			/* Let's try again... */
 			break;
-		case -ENOMEM:
+		case -EFAULT:
+		case -EHWPOISON:
 			/*
 			 * For guest_memfd, this indicates that it failed to
 			 * create a folio to back the memory. Inform userspace.
 			 */
 			if (is_gmem)
-				return 0;
-			/* Otherwise, let's try again... */
-			break;
-		case -EFAULT:
-		case -EIO:
-		case -EHWPOISON:
-			if (is_gmem)
-				return 0;
+				return ret;
 			fallthrough;
+		case -EIO:
 		case -EINVAL:
 		case -ENOENT:
 		case -EACCES:

base-commit: 7fd2df204f342fc17d1a0bfcd474b24232fb0f32
-- 
2.54.0

