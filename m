Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD23E30F526
	for <kvmarm@lists.linux.dev>; Mon, 11 May 2026 15:15:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778512503; cv=none; b=t8ufFG4dkSqQlt5/kRRYs3xHykuP6hB/Ppn/2KVxv/hx2z0EuBynym02Kq3/qA7+Zltv/KXU5QFdvqRndaH2DLysQL+axBKGvU9XutOm5WwMkKuK5tAt7uAP2LLDk4Dj55b6MFwoRpl6jsUBhX/RUi3rPf4DH06tI1ojkFgu700=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778512503; c=relaxed/simple;
	bh=hzDHO2geL5UT1GbX8y8vqoSOsjXy+ECCYRicoP1YYUk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=iYyf6mLqiaA35cxOLn5sW8k/8FvFUcfsgWlItTwx6+6Yus93ZSxk86Dr0x1ygJQHc5swgULKh0bWDn2UYZFrS1O84mpLlPyIOkFV5Xw0WCFxH2DJvj7asKEaCs0GNiKyZecCUGbKw1IvQ/nTOkgtCTztr/u5/eOKFxpJEdQYf+M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=T512F1mh; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="T512F1mh"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1778512501;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=bHbDw2kQDVt9bJG46JUREywkjRHfZCqW19vv3OS9bjw=;
	b=T512F1mhtyjNzYLIl5msvqb1Fat1cYJYou0wiKkJNi93uNniihquQPTEBPrYYAo7DR1lNR
	VRu98JhvrD5ix2/XEyLpNbdG5UP/hf7oJcUvJMatb/KbY/gJlfA/ZkzsOyzQvj/TH9/FUs
	9/1J+2d8SSnBTp4NvymIIDPaDLH1OU8=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-689-AdPGODgCPFCfv-AnQdUCAw-1; Mon,
 11 May 2026 11:14:56 -0400
X-MC-Unique: AdPGODgCPFCfv-AnQdUCAw-1
X-Mimecast-MFC-AGG-ID: AdPGODgCPFCfv-AnQdUCAw_1778512493
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id CE1291955EB1;
	Mon, 11 May 2026 15:14:51 +0000 (UTC)
Received: from [10.44.34.38] (unknown [10.44.34.38])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 50A331800286;
	Mon, 11 May 2026 15:14:43 +0000 (UTC)
Message-ID: <6afc4b95-3c15-4d71-877d-19b84e91ce05@redhat.com>
Date: Mon, 11 May 2026 17:14:42 +0200
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] Documentation: KVM: Document guest-visible compatibility
 expectations
To: David Woodhouse <dwmw2@infradead.org>, Jonathan Corbet <corbet@lwn.net>,
 Shuah Khan <skhan@linuxfoundation.org>, kvm@vger.kernel.org,
 linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
 Sean Christopherson <seanjc@google.com>, Jim Mattson <jmattson@google.com>
Cc: Oliver Upton <oupton@kernel.org>, Joey Gouly <joey.gouly@arm.com>,
 Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu
 <yuzenghui@huawei.com>, Catalin Marinas <catalin.marinas@arm.com>,
 Will Deacon <will@kernel.org>, Raghavendra Rao Ananta <rananta@google.com>,
 Eric Auger <eric.auger@redhat.com>, Kees Cook <kees@kernel.org>,
 Arnd Bergmann <arnd@arndb.de>, Nathan Chancellor <nathan@kernel.org>,
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
 linux-kselftest@vger.kernel.org
References: <6856b269d2af706eae397e0cf9c1231f89d9a932.camel@infradead.org>
From: Paolo Bonzini <pbonzini@redhat.com>
Autocrypt: addr=pbonzini@redhat.com; keydata=
 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
In-Reply-To: <6856b269d2af706eae397e0cf9c1231f89d9a932.camel@infradead.org>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111
X-Mimecast-MFC-PROC-ID: 8WENLj03PTvHE5MYpNCjCVaXptkerhNV_RwcWaIyn00_1778512493
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 5/11/26 10:57, David Woodhouse wrote:
> From: David Woodhouse <dwmw@amazon.co.uk>
> 
> Document the expectation that KVM maintains guest-visible compatibility
> across host kernel upgrades and rollbacks.  Specifically:
> 
>   - State saved/restored via KVM ioctls must be sufficient for live
>     migration (and live update) between kernel versions.
> 
>   - Where a new kernel introduces a guest-visible change, it provides a
>     mechanism for userspace to select the previous behaviour.
> 
>   - This allows both forward migration (upgrade) and backward migration
>     (rollback) of guests.
> 
> These expectations have been implicitly required on x86 but were not
> explicitly documented. Harmonise the expectations across all of KVM.

One big part of achieving this on x86 is the handling of CPUID.  Despite 
all the mess that KVM_SET_CPUID2 is (and sometimes the underlying 
architecture too, as Jim Mattson would certainly agree), KVM is 
generally able to provide a consistent view of its configuration to the 
guest.  This doesn't quite extend to compatibility across vendors, but 
it does work across processor generations from either Intel or AMD.

I understand that Arm traditionally had much more trouble than x86 with 
vendor-specified behavior that goes beyond the set of architectural 
features, so we may need to tune the expectations.  However, I agree 
with David that this is needed at least as long as the host CPU does not 
change.

Thanks,

Paolo

> Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
> ---
>   Documentation/virt/kvm/api.rst              | 14 ++++++++++++++
>   Documentation/virt/kvm/review-checklist.rst | 20 ++++++++++++++------
>   2 files changed, 28 insertions(+), 6 deletions(-)
> 
> diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
> index 269970221797..864f3daa7acb 100644
> --- a/Documentation/virt/kvm/api.rst
> +++ b/Documentation/virt/kvm/api.rst
> @@ -97,6 +97,20 @@ Instead, kvm defines extension identifiers and a facility to query
>   whether a particular extension identifier is available.  If it is, a
>   set of ioctls is available for application use.
>   
> +KVM will ensure that the state that can be saved and restored via the
> +KVM ioctls is sufficient to allow migration of a running guest between
> +host kernels while maintaining full compatibility of the guest-visible
> +device model.  This includes migration to newer kernels (upgrade) and
> +to older kernels (rollback), provided that the older kernel supports
> +the set of features exposed to the guest.  Where a new kernel version
> +introduces a guest-visible change, it will provide a mechanism (such
> +as a capability or a device attribute) that allows userspace to select
> +the previous behaviour.  This serves two purposes: guests migrated
> +from an older kernel can continue to run with their original
> +observable environment, and new guests launched on the newer kernel
> +can be configured to match the feature set of the older kernel, so
> +that they remain migratable to the older kernel in case of rollback.
> +
>   
>   4. API description
>   ==================
> diff --git a/Documentation/virt/kvm/review-checklist.rst b/Documentation/virt/kvm/review-checklist.rst
> index 053f00c50d66..f0fbe1577a90 100644
> --- a/Documentation/virt/kvm/review-checklist.rst
> +++ b/Documentation/virt/kvm/review-checklist.rst
> @@ -18,22 +18,30 @@ Review checklist for kvm patches
>   5.  New features must default to off (userspace should explicitly request them).
>       Performance improvements can and should default to on.
>   
> -6.  New cpu features should be exposed via KVM_GET_SUPPORTED_CPUID2,
> +6.  Guest-visible changes must not break migration compatibility.  A guest
> +    migrated from an older kernel must be able to run with its original
> +    observable environment, and a guest launched on a newer kernel must be
> +    configurable to match the older kernel's feature set for rollback.
> +    Where a change alters guest-visible behaviour, provide a mechanism
> +    (capability, device attribute, etc.) for userspace to select the
> +    previous behaviour.
> +
> +7.  New cpu features should be exposed via KVM_GET_SUPPORTED_CPUID2,
>       or its equivalent for non-x86 architectures
>   
> -7.  The feature should be testable (see below).
> +8.  The feature should be testable (see below).
>   
> -8.  Changes should be vendor neutral when possible.  Changes to common code
> +9.  Changes should be vendor neutral when possible.  Changes to common code
>       are better than duplicating changes to vendor code.
>   
> -9.  Similarly, prefer changes to arch independent code than to arch dependent
> +10. Similarly, prefer changes to arch independent code than to arch dependent
>       code.
>   
> -10. User/kernel interfaces and guest/host interfaces must be 64-bit clean
> +11. User/kernel interfaces and guest/host interfaces must be 64-bit clean
>       (all variables and sizes naturally aligned on 64-bit; use specific types
>       only - u64 rather than ulong).
>   
> -11. New guest visible features must either be documented in a hardware manual
> +12. New guest visible features must either be documented in a hardware manual
>       or be accompanied by documentation.
>   
>   Testing of KVM code

