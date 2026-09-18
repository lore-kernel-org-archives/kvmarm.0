Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 86F5A4BD36B;
	Fri, 18 Sep 2026 08:59:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789721961; cv=none; b=joVqwJKV3wOdi+SNae+nVBSjM4rjQUP2Hz9xLo3jxSTmhLtyYsrJwVqw8FTgm0Ug+ooN95rYYlrbszw2EqSPfTwUrlpTTuvxg1l40iq/pZyWIF7Gv7C6ACYOyZDnj7OTgaZRRw/Oh6VOs+I03nW798JUxkZsRTbnsK44BJrRGYQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789721961; c=relaxed/simple;
	bh=1M1QtH7NdzkDYZ09YQzOvcKU43QqUz+DMQ3u7GB+BTA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=MdyDjQ8AZLWyX9fK0TEqIQn0H01WPJSiHY+1V1uAUNuvZszsy3i/XRFWP9+oPnn2u14sHvB9lKKn11DX2a83ucDcYUdkxJLhrbtWFs0pniB2T8ZrPsYLllT3hKgJKJR2KJWYgFu60lpPBORtS7aENuywcfXPV/gsVHbCyMr0XW4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=gMhNVUf7; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="gMhNVUf7"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id F1C06168F;
	Fri, 18 Sep 2026 01:59:14 -0700 (PDT)
Received: from [10.57.6.197] (unknown [10.57.6.197])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id A15FA3F86F;
	Fri, 18 Sep 2026 01:59:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1789721958; bh=1M1QtH7NdzkDYZ09YQzOvcKU43QqUz+DMQ3u7GB+BTA=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=gMhNVUf7FU14C3AvALw/IJRAU0r5ZC7LybOmBcwkNWc+DAjCckG9KnP01I1wmlwyC
	 jwkpPhL4ENWatRqaHBHlgShatqY/nVK4er+43d5StSotzGLtEXPJotp0f1EKvtUnpj
	 Bzj946PL96YGt37gh2bvsO5zxsWPabKAQrRAacd0=
Message-ID: <e26cbb4e-84e2-4fcc-9eb0-93bfd4aff4a7@arm.com>
Date: Fri, 18 Sep 2026 09:59:14 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v18 05/23] KVM: arm64: Track the type of VM in kvm_arch
Content-Language: en-GB
To: Fuad Tabba <fuad.tabba@linux.dev>
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev, maz@kernel.org,
 will@kernel.org, catalin.marinas@arm.com, linux-kernel@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, steven.price@arm.com,
 aneesh.kumar@kernel.org, oupton@kernel.org, gshan@redhat.com,
 joey.gouly@arm.com, yuzenghui@huawei.com, linux-coco@lists.linux.dev,
 gankulkarni@os.amperecomputing.com, sdonthineni@nvidia.com,
 alpergun@google.com, fj0570is@fujitsu.com, WeiLin.Chang@arm.com,
 lpieralisi@kernel.org, enju.kohei@fujitsu.com
References: <20260915160141.3543048-1-suzuki.poulose@arm.com>
 <20260915160141.3543048-6-suzuki.poulose@arm.com>
 <CA+EHjTz65G0MM=tOrzmk=jMweBX1us6FqfrmSkQs4KSyAEoxhg@mail.gmail.com>
From: Suzuki K Poulose <suzuki.poulose@arm.com>
In-Reply-To: <CA+EHjTz65G0MM=tOrzmk=jMweBX1us6FqfrmSkQs4KSyAEoxhg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 17/09/2026 12:24, Fuad Tabba wrote:
> Hi Suzuki,
> 
> On Tue, 15 Sep 2026 17:01:23 +0100, Suzuki K Poulose
> <suzuki.poulose@arm.com> wrote:
> [...]
>> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> [...]
>> +#define kvm_vm_hyp_is_pkvm(kvm)                (is_protected_kvm_enabled())
> 
> I'd keep is_protected_kvm_enabled() at the three call sites: this
> takes a VM and ignores it, so it reads as per-VM when it's the mode,
> and patch 20's comment about not being able to use the kvm_vm_ helpers
> with a NULL kvm goes away too.

Actually, that comment is invalid. kvm_arch_vm_ioctl_allowed, is only
called from the kvm_arch_vm_ioctl() with a valid kvm instance. I have 
changed that hunk to:


+/*
+ * Check whether the KVM VM IOCTL is allowed. For pKVM and Realm VMs, 
certain
+ * ioctls are not allowed. Further, certain features are allowed only for
+ * non-protected VMs in pKVM.
+ */
+static inline bool kvm_arch_vm_ioctl_allowed(struct kvm *kvm, unsigned 
int ioctl)
+{
+       long ext;
+       int r;
+
+       /*
+        * We are guaranteed to be called with a valid kvm instance, as the
+        * only caller is kvm_arch_vm_ioctl(). Catch any deviations, as we
+        * rely on the kvm instance below.
+        */
+       if (WARN_ON_ONCE(!kvm))
+               return false;
+
+       /* Cover both pKVM host and Realm VMs */
+       if (!kvm_vm_hyp_is_distrusting(kvm))
+               return true;
+

I resorted to is_protected_kvm_enabled() to make it faster than using
the vm_flavor checks. I could rever those anyways.

> 
>> diff --git a/arch/arm64/kvm/hyp/nvhe/pkvm.c b/arch/arm64/kvm/hyp/nvhe/pkvm.c
> [...]
>> @@ -432,7 +432,7 @@ static void init_pkvm_hyp_vm(struct kvm *host_kvm, struct pkvm_hyp_vm *hyp_vm,
>>
>>           hyp_vm->host_kvm = host_kvm;
>>           hyp_vm->kvm.created_vcpus = nr_vcpus;
>> -        hyp_vm->kvm.arch.pkvm.is_protected = READ_ONCE(host_kvm->arch.pkvm.is_protected);
>> +        hyp_vm->kvm.arch.vm_flavor = READ_ONCE(host_kvm->arch.vm_flavor);
> 
> Could EL2 reduce this to VM_PKVM or VM_PROTECTED_PKVM here instead of
> storing what it reads? The host supplies the value, and it's now an
> enum rather than a bool. Patch 12 relies on EL2 only ever seeing those
> two, and with VM_REALM above the marker a host-written value passes
> kvm_vm_is_protected() but not the == form, if EL2 ever adds one.

Do you mean something like :

	if (kvm_vm_is_protected_pkvm(host_kvm))
		hyp_vm->kvm.arch.vm_flavor = VM_PROTECTED_PKVM;
	else
		hyp_vm->kvm.arch.vm_flavor = VM_PKVM;

Do we additionally need to WARN_ON() if we encounter a VM_REALM ?

> 
> Both hunks are new since v17, which is where I gave the Reviewed-by.
> Happy to keep it if you can settle these please.

Apologies, I thought this one didn't change, but later patches changes 
them, which is why I kept this.

Cheers
Suzuki

