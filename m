Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66A5427727
	for <kvmarm@lists.linux.dev>; Tue,  6 Dec 2022 18:16:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA2EAC433D6;
	Tue,  6 Dec 2022 18:16:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1670350609;
	bh=macQQ74pjNjmKFm8T+wbES3REUCkFjh+lVvmQilsrUY=;
	h=From:To:Cc:Subject:Date:From;
	b=dYrsTt3f5z+/AXYuybQ15f05xy/VElaugfomTFjhbLP/qg9Uti9Fls6H6JUwHL/fA
	 fl8rendKXr2VbIz1PsCMsrkrsE1BSDM8//kKjrHtNvYkEYwriI4ufmzMvbB9IpIr5D
	 sEYocOUvA0Ze2//cjrMT3dOv5Wjd7xRskTGS+MdNNqB/Iin2zLKyz7QV3Jtghk+9Vu
	 mpOalcc5E1PjHjgLx9byYfihjjbSvO+kAuuvKWNFvM86dNLZBpj7kAeUiYsAmlz0Ne
	 yDDaR8kGnUMY0Z8mSZbYxqbqwhWpX9G3gj5RfEQr2QSIPXrTxfcRH8b7hpKMiWRnYd
	 86Z6QA5zLWnCg==
From: Mark Brown <broonie@kernel.org>
To: Paolo Bonzini <pbonzini@redhat.com>,
	Shuah Khan <shuah@kernel.org>,
	Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev,
	kvm@vger.kernel.org,
	linux-next@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	Stephen Rothwell <sfr@canb.auug.org.au>,
	Mark Brown <broonie@kernel.org>,
	Sean Christopherson <seanjc@google.com>,
	Ricardo Koller <ricarkol@google.com>
Subject: [PATCH] KVM: selftests: Fix build due to ucall_uninit() removal
Date: Tue,  6 Dec 2022 18:15:06 +0000
Message-Id: <20221206181506.252537-1-broonie@kernel.org>
X-Mailer: git-send-email 2.30.2
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-Developer-Signature: v=1; a=openpgp-sha256; l=1809; i=broonie@kernel.org; h=from:subject; bh=macQQ74pjNjmKFm8T+wbES3REUCkFjh+lVvmQilsrUY=; b=owEBbQGS/pANAwAKASTWi3JdVIfQAcsmYgBjj4apcRMzRY/3tffeY2BaujjTzJ6CZMq8Xxzk9Awb SDUV+3GJATMEAAEKAB0WIQSt5miqZ1cYtZ/in+ok1otyXVSH0AUCY4+GqQAKCRAk1otyXVSH0NlRB/ 9LWXJwFvylGOiRN1bWQfLyw9jaJOwv5Pf4HkB9GFM3Tip2CqJRRkV3sF4BQDX1PCMU7epSd0usq1T/ evWNcCpQZSFQ0bXovG4j4+cmHVim5y4EKIGWBqlR+dZ5nZsjTEf/nogWA0JoCmnG/rah6oh+SNNwsb /3NKaaDA3If0eGTSXcPe38ZWpPEd3DnNaqZYnnkyK84jVR2LE2jGep11ygv2Buq6ccxj5GAMLUa7JG 8N0gSW7ni2iwN7+IeUVEh5+X1kYgBJpufhUskYmz73ModYIPVKElZBPUxNosmzRtXGZCeXbwE18Qwf 05ADCKlxRAF18A3etfhA0+9mCFFcwR
X-Developer-Key: i=broonie@kernel.org; a=openpgp; fpr=3F2568AAC26998F9E813A1C5C3F436CA30F5D8EB
Content-Transfer-Encoding: 8bit

Today's -next fails to build on arm64 due to:

In file included from include/kvm_util.h:11,
                 from aarch64/page_fault_test.c:15:
include/ucall_common.h:36:47: note: expected ‘vm_paddr_t’ {aka ‘long unsigned int’} but argument is of type ‘void *’
   36 | void ucall_init(struct kvm_vm *vm, vm_paddr_t mmio_gpa);
      |                                    ~~~~~~~~~~~^~~~~~~~
aarch64/page_fault_test.c:725:2: warning: implicit declaration of function ‘ucall_uninit’; did you mean ‘ucall_init’? [-Wimplicit-function-declaration]
  725 |  ucall_uninit(vm);
      |  ^~~~~~~~~~~~
      |  ucall_init

which is caused by commit

interacting poorly with commit

   28a65567acb5 ("KVM: selftests: Drop now-unnecessary ucall_uninit()")

As is done for other ucall_uninit() users remove the call in the newly added
page_fault_test.c.

Fixes: 28a65567acb5 ("KVM: selftests: Drop now-unnecessary ucall_uninit()")
Fixes: 35c581015712 ("KVM: selftests: aarch64: Add aarch64/page_fault_test")
Signed-off-by: Mark Brown <broonie@kernel.org>
Cc: Sean Christopherson <seanjc@google.com>
Cc: Ricardo Koller <ricarkol@google.com>
Cc: Marc Zyngier <maz@kernel.org>
---
 tools/testing/selftests/kvm/aarch64/page_fault_test.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/tools/testing/selftests/kvm/aarch64/page_fault_test.c b/tools/testing/selftests/kvm/aarch64/page_fault_test.c
index 05bb6a6369c2..4ef89c57a937 100644
--- a/tools/testing/selftests/kvm/aarch64/page_fault_test.c
+++ b/tools/testing/selftests/kvm/aarch64/page_fault_test.c
@@ -722,7 +722,6 @@ static void run_test(enum vm_guest_mode mode, void *arg)
 
 	vcpu_run_loop(vm, vcpu, test);
 
-	ucall_uninit(vm);
 	kvm_vm_free(vm);
 	free_uffd(test, pt_uffd, data_uffd);
 
-- 
2.30.2

