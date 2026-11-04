Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793823428;
	b=JTzTD74wYDyRtTRNi1qETdKiGsnkWomRPoFvgrchwmX2BFgPC6GD2DBUWHCk5+TAOwNK
	 EfkEXCJUb2uKw6/nCft+BGDK2n+EEBL5t2MwczFt8iTioHjfEx6GnUuGOC7DqJ9dvcZuo
	 YMVylp9X9cYuehcwWHfNOT1vHFQ2T9WuTblwUbR4FPHRxLtkwdmPCYCmt/thumu89/YPZ
	 7+iFkIgBq/oZ1JvUS18vcOVPaeFfkp5OJXFSE8gPWAxeAkJucYHgqOId8O6cw1LVfK/bW
	 aj9bMuF/2pc39fkd0aKbdhH/hYRNv6LnK6BrXNxai9WKpQAgqsr8hkXJ353l2Us7sjQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793823428;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=pfxYvjvYdIAyCNhr0jOTYpbDncNpeWRb1+wAZAPntLc=;
	b=0dOz1HqaWGokHLy/Fgtqxy6RJnzPpvFmQaHVimjiWyR3uNbfavMzFtRbB2sI7o+XScHz
	 Hqx9ncl1Oi5keyRNJeBjvygqGZDIjOm3yp2HOjNLXgvqwpidHL8aplaBOyh4T1Z4ahRdn
	 24QoU8pzVS5JoRYi8CdeExFycA7AA/0xmYaVmvLwfxR5x+JoKTzNHv51PMJnj5gE+1EmA
	 h3GCArBabpG3x2kDAF76qu2SpAq6dWKIkQL8BJYyC6nUp+VTw8AZaaWvk9jSEyD0U70PH
	 j9rQVb5gMuHMTrnakAfS++BIBQ9SY4LSARjU267xWx5JwNuejt6IKPxOmojzxhSQl4A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=YMLU4GfN;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68409606A330;
	Wed,  4 Nov 2026 20:17:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=YMLU4GfN
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B9DD1F000C1;
	Wed,  4 Nov 2026 20:17:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793823428;
	bh=pfxYvjvYdIAyCNhr0jOTYpbDncNpeWRb1+wAZAPntLc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=YMLU4GfNoVK9OsQUzCCsz4wvztjE+suetDUfWWmbaFn5hnfbXs55WXcat2oTCxOS2
	 LBL6YqW5Vzp7iBsgswBByutxciMdD0mJOSMMavYECYHGIka0rdl/uK7LsRT88oA96Q
	 mJE7nKa5KDMCULtwsjv5jggmMjEh1jUhBWu+9MvoePXDDvRhh83H7AP1AYAhvp53fg
	 UCJoKsto8wopb1qL3cRZAoFRiFIcikLxyXsFwg05qJU32uLUHsjh9PPGVu+YHiygGe
	 Rmj0GAJKBUSLsFclJzThC4u35Qo8Q+/XCXWahH5hPDNeE/6lql8Qvx4CZbNlp12WWK
	 6wnR4p51hM9+A==
Date: Wed, 4 Nov 2026 12:17:07 -0800
From: Oliver Upton <oupton@kernel.org>
To: sashiko-reviews@lists.linux.dev
Cc: kvmarm@lists.linux.dev, Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH 1/8] KVM: arm64: nv: Disallow KVM_CAP_ARM_MTE + FEAT_EL2
Message-ID: <auuSw8FYXR4rRJA9@kernel.org>
References: <20261104192124.3932743-1-oupton@kernel.org>
 <20261104192124.3932743-2-oupton@kernel.org>
 <sashiko-outbox-197967@kernel.org>
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <sashiko-outbox-197967@kernel.org>

On Wed, Nov 04, 2026 at 07:37:54PM +0000, sashiko-bot@kernel.org wrote:
> Because kvm_vm_ioctl_check_extension() in arch/arm64/kvm/arm.c still reports
> KVM_CAP_ARM_EL2 as supported on a VM fd where KVM_CAP_ARM_MTE was enabled:
> 
> 	case KVM_CAP_ARM_EL2:
> 		r = cpus_have_final_cap(ARM64_HAS_NESTED_VIRT);
> 		break;
> 
> and vm_supports_el2() does not check !request_mte, aarch64_vcpu_setup() passes
> KVM_ARM_VCPU_HAS_EL2 to KVM_ARM_VCPU_INIT, which now fails with -EINVAL unless
> the test is run with NV=0.
> 
> Should kvm_vm_ioctl_check_extension() gate KVM_CAP_ARM_EL2 on
> !kvm_has_mte(kvm) (or vm_supports_el2() check !request_mte) so userspace and
> selftests do not request EL2 on MTE-enabled VMs?

Sure, we can hide the cap but that's sensitive to ioctl ordering.
Ultimately it's up to userspace to not do something stupid. So we should
just document this rule.

Marc, if you feel like squashing:


diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index e95c9cda085d..4ce4166d415f 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -3602,6 +3602,7 @@ Possible features:
 	- KVM_ARM_VCPU_HAS_EL2: Enable Nested Virtualisation support,
 	  booting the guest from EL2 instead of EL1.
 	  Depends on KVM_CAP_ARM_EL2.
+          Cannot be enabled if KVM_CAP_ARM_MTE has been enabled for the VM.
 	  The VM is running with HCR_EL2.E2H being RES1 (VHE) unless
 	  KVM_ARM_VCPU_HAS_EL2_E2H0 is also set.
 
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index a750413c684b..4108ff30830c 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -480,7 +480,11 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 		r = cpus_have_final_cap(ARM64_HAS_32BIT_EL1);
 		break;
 	case KVM_CAP_ARM_EL2:
-		r = cpus_have_final_cap(ARM64_HAS_NESTED_VIRT);
+		/* Nested virt is incompatible with MTE */
+		if (kvm && kvm_has_mte(kvm))
+			r = 0;
+		else
+			r = cpus_have_final_cap(ARM64_HAS_NESTED_VIRT);
 		break;
 	case KVM_CAP_ARM_EL2_E2H0:
 		r = cpus_have_final_cap(ARM64_HAS_HCR_NV1);

Thanks,
Oliver
