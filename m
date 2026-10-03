Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 54787175A7B;
	Sat,  3 Oct 2026 07:07:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791011268; cv=none; b=AyC6KdrI8OT2DArumwtZUUjwX5gEt+XvS0hSpKyKt6i2TI7NJMgPkQiS53wBLHiBhRN+A/pkL+9H/kpQfY7V4wmkdEXMURZM3WNhjDnC81fQI9sCbhrkpqTN1EDkgPBIHP/9/XM/qHSQHR0Hekawm3gXznKLBQmaN+sBGI0TBWc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791011268; c=relaxed/simple;
	bh=fcWSRwYqC7iDa1xgy0kg2U7wsZFZJLJk1a4HcvjWK5I=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=Dydf4q3W0Voyf50XgviZJYn848C+//9W7IqBL7BuF9M68WWzfR+nuuCYvsK0qwsrYnp/HdKZlOARZ3N/TtlyK2C73+/qQHqC84382E3QqSeLJb5GQoEh50tEfQeTPZJAob4GM49upCADuZpWTglBBEYCZWn3qm6PuJMTLuKAQ5o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=PPj0gM2R; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="PPj0gM2R"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 25B942F;
	Sat,  3 Oct 2026 00:07:43 -0700 (PDT)
Received: from [10.57.8.170] (unknown [10.57.8.170])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 163E63F85F;
	Sat,  3 Oct 2026 00:07:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1791011266; bh=fcWSRwYqC7iDa1xgy0kg2U7wsZFZJLJk1a4HcvjWK5I=;
	h=Date:Subject:From:To:Cc:References:In-Reply-To:From;
	b=PPj0gM2RRh21a27DM/q2/tyeKO0DsJnY3GH0PWCJS7UVYAEtbBp7Ez9b8ZaULD6Xj
	 2dnwFTOkOPfgCECZeEJndniLsNWLRZQ+EHqxBlRJDHEgJ740NaFO9F3W9cUZE9u/PJ
	 y52tz3Ck56R1gHYTC5TcmWjSuYfZE7m4ksWwojiM=
Message-ID: <d7a398b3-5cbe-4a1c-bdd3-c1c5925dfc33@arm.com>
Date: Sat, 3 Oct 2026 08:07:39 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v21 05/23] KVM: arm64: Track the type of VM in kvm_arch
Content-Language: en-GB
From: Suzuki K Poulose <suzuki.poulose@arm.com>
To: Marc Zyngier <maz@kernel.org>, Fuad Tabba <tabba@google.com>
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev, will@kernel.org,
 catalin.marinas@arm.com, linux-kernel@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, steven.price@arm.com,
 aneesh.kumar@kernel.org, oupton@kernel.org, gshan@redhat.com,
 joey.gouly@arm.com, yuzenghui@huawei.com, linux-coco@lists.linux.dev,
 gankulkarni@os.amperecomputing.com, sdonthineni@nvidia.com,
 alpergun@google.com, fj0570is@fujitsu.com, WeiLin.Chang@arm.com,
 lpieralisi@kernel.org, enju.kohei@fujitsu.com, sudeep.holla@arm.com,
 jonathan.cameron@oss.qualcomm.com
References: <20261001210703.1597150-1-suzuki.poulose@arm.com>
 <20261001210703.1597150-6-suzuki.poulose@arm.com>
 <CA+EHjTxtatPyGcyvEyR129cqUiAYcO_cxRVtwZO0ckZsOnD7TA@mail.gmail.com>
 <86se2o2rbs.wl-maz@kernel.org>
 <CA+EHjTwHuJ0u_TTP46zNFKFmBP124XHHLUVhkAUSyfhe92=41w@mail.gmail.com>
 <86pkxs2npx.wl-maz@kernel.org>
 <CA+EHjTy4rb+6z0bqh7sPqACES0EDpURdeoyiFGmdw3p0PENcOQ@mail.gmail.com>
 <86o6dc2ka1.wl-maz@kernel.org> <83e79119-b331-4640-b2c7-cc8135d71c77@arm.com>
In-Reply-To: <83e79119-b331-4640-b2c7-cc8135d71c77@arm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 03/10/2026 06:53, Suzuki K Poulose wrote:
> On 02/10/2026 16:29, Marc Zyngier wrote:
>> On Fri, 02 Oct 2026 15:37:00 +0100,
>> Fuad Tabba <tabba@google.com> wrote:
>>>
>>> Hi Marc,
>>>
>>> On Fri, 02 Oct 2026 15:15:06 +0100, Marc Zyngier <maz@kernel.org> wrote:
>>> [...]
>>>> Honestly, we introduce the flavor stuff to make it easy to match
>>>> things on a particular VM type in a readable way. So why isn't this
>>>> reading:
>>>>
>>>>          if (vcpu->kvm->arch.vm_flavor != VM_PROTECTED_PKVM)
>>>>                  return;
>>>
>>> I know this is a sketch, but just in case: that's inverted. The sync
>>> only applies to non-protected pKVM VMs (EL2 ignores it for protected
>>> ones), so it would be != VM_PKVM.
>>
>> See what I meant about this stuff being completely intractable? I
>> still have no idea what it means! ;-)
>>
> 
> Just to be clear: unprotected_pkvm() != (vm_flavor != VM_PROTECED_PKVM).
> Rather, unprotected_pkvm => (vm_flavor == VM_PKVM).
> 
> And the code wanted to bail out early for !unprotected_pkvm(). We can
> stick in "is_protected_kvm_enabled()" for unprotected_pkvm predicate
> 
> But, I can drop the helper and use the vm_flavor check.

FWIW: Here is the diff for the above change. If you are happy
with the following, I could fold this in.


diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 90547fbbc8ad7..bcec14c587119 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -772,7 +772,7 @@ void kvm_arch_vcpu_put(struct kvm_vcpu *vcpu)
                 kvm_call_hyp_nvhe(__pkvm_vcpu_put);

                 /* __pkvm_vcpu_put implies a sync of the state */
-               if (kvm_vm_is_unprotected_pkvm(vcpu->kvm))
+               if (vcpu->kvm->arch.vm_flavor == VM_PKVM)
                         vcpu_set_flag(vcpu, PKVM_HOST_STATE_DIRTY);
         }

@@ -1006,7 +1006,7 @@ int kvm_arch_vcpu_run_pid_change(struct kvm_vcpu 
*vcpu)

         if (is_protected_kvm_enabled()) {
                 /* Start with the vcpu in a dirty state */
-               if (kvm_vm_is_unprotected_pkvm(vcpu->kvm))
+               if (vcpu->kvm->arch.vm_flavor == VM_PKVM)
                         vcpu_set_flag(vcpu, PKVM_HOST_STATE_DIRTY);
                 ret = pkvm_create_hyp_vm(kvm);
                 if (ret)
diff --git a/arch/arm64/kvm/handle_exit.c b/arch/arm64/kvm/handle_exit.c
index 384c5d258c7f8..4e16e7d165515 100644
--- a/arch/arm64/kvm/handle_exit.c
+++ b/arch/arm64/kvm/handle_exit.c
@@ -490,7 +490,7 @@ static void handle_exit_pkvm_state(struct kvm_vcpu 
*vcpu, int exception_index)
  {
         int exception_code = ARM_EXCEPTION_CODE(exception_index);

-       if (!kvm_vm_is_unprotected_pkvm(vcpu->kvm))
+       if (!is_protected_kvm_enabled() || vcpu->kvm->arch.vm_flavor != 
VM_PKVM)
                 return;

         /*



Cheers
Suzuki>
> Cheers
> Suzuki
> 
>>     M.
>>
> 

