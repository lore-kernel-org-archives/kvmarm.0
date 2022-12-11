Received: from mail-pj1-f52.google.com (mail-pj1-f52.google.com [209.85.216.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26D221366
	for <kvmarm@lists.linux.dev>; Sun, 11 Dec 2022 05:25:37 +0000 (UTC)
Received: by mail-pj1-f52.google.com with SMTP id u15-20020a17090a3fcf00b002191825cf02so8986322pjm.2
        for <kvmarm@lists.linux.dev>; Sat, 10 Dec 2022 21:25:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=daynix-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=oOTSqgAtFN3jDhT+qpsM6UoRhjwrXSuk6Uc/WgaDg/A=;
        b=DoqE4+ZzQw2vP1eFEB1ig3MLOd/ZfqWXZO/9pxEUYH+5mFmiSzdP0DhHYZgq8s5v0a
         hGsAyKZOHmYUpeAta5yZ6Y3X3aiLy3acWmSnG7da5NNw9NbLPwKFBr/0llkk1iE/WPFM
         5XLwrzqSNGlQ4q5aFTqbUpB9MHMdKMgOOBnykCVk2wirD0SNNLHGDy50SyI+DhUx+P2v
         GJK84LDqa5zP7zlofCd0hJrqqouywTfBXeuguBJwcb9jXs3qvGKLIk6MHQ2PKWkoydS9
         YDFZsu5Y/bv7LHZF6Yennb5KcH+ry3FlL3a/vT2MNT8hITFhZnIv7dkwPx9DOIgiPFBk
         zwaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=oOTSqgAtFN3jDhT+qpsM6UoRhjwrXSuk6Uc/WgaDg/A=;
        b=5m6hREHTcfHizg6zAiiek8NzcizFO9WnwfOzfW6sR3KxXoQiEg6Suj5dYnWK5J2rf7
         XMr+LU5OIrdjOAmCRYVuKjB1jmPyzusOSafrWtGti4U7v5vlrIobJ8t4R7QCZfXOpUls
         x7NAEnn/Cli74ggYGP+qxlogDkq/LTGnonRJLC0MKVmlKNGFLwsGcixxdC+I1yTasNTD
         7s5d5yzJrLcjsKR2nuBUyy2VpjQgVP22J1Tj+YvGkW312c3CGApvZEs56KVfVsvlm5Ay
         KfX5mvg6z6y3BJKG+sGWoep3CF6T2vKSxE55SUSAFuVb8gx5X9q47b3xd2MxNG7Ro7X/
         3pAg==
X-Gm-Message-State: ANoB5pkHWAROgq6y6u3RhdB+8Ze6puONQsO9ah+8XIiaXizO492dtWeJ
	hIPE10+aASqTQcsfudobNAE+3w==
X-Google-Smtp-Source: AA0mqf5NtZyYbVGeTSUf0CHgR1BikGIibJwSXTLXG/PjRPMoHMI7WHp9+jch2m2J3Ikv9qSkOAPBFA==
X-Received: by 2002:a17:902:6547:b0:189:5506:a7 with SMTP id d7-20020a170902654700b00189550600a7mr11294899pln.19.1670736336582;
        Sat, 10 Dec 2022 21:25:36 -0800 (PST)
Received: from ?IPV6:2400:4050:c360:8200:8ae8:3c4:c0da:7419? ([2400:4050:c360:8200:8ae8:3c4:c0da:7419])
        by smtp.gmail.com with ESMTPSA id n1-20020a170902d2c100b00188a908cbddsm3710707plc.302.2022.12.10.21.25.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 10 Dec 2022 21:25:36 -0800 (PST)
Message-ID: <88bdcca8-4df4-15ff-2e88-c53255b1fe30@daynix.com>
Date: Sun, 11 Dec 2022 14:25:31 +0900
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.1
Subject: Re: [PATCH 0/3] KVM: arm64: Handle CCSIDR associativity mismatches
Content-Language: en-US
To: Marc Zyngier <maz@kernel.org>, Akihiko Odaki <akihiko.odaki@gmail.com>
Cc: linux-kernel@vger.kernel.org, kvmarm@lists.linux.dev,
 kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org,
 Mathieu Poirier <mathieu.poirier@linaro.org>,
 Oliver Upton <oliver.upton@linux.dev>,
 Suzuki K Poulose <suzuki.poulose@arm.com>,
 Alexandru Elisei <alexandru.elisei@arm.com>,
 James Morse <james.morse@arm.com>, Will Deacon <will@kernel.org>,
 Catalin Marinas <catalin.marinas@arm.com>, asahi@lists.linux.dev,
 Alyssa Rosenzweig <alyssa@rosenzweig.io>, Sven Peter <sven@svenpeter.dev>,
 Hector Martin <marcan@marcan.st>
References: <20221201104914.28944-1-akihiko.odaki@daynix.com>
 <867czbmlh1.wl-maz@kernel.org>
 <50499ee9-33fe-4f5d-9d0a-76ceef038333@daynix.com>
 <87lenqu37t.wl-maz@kernel.org>
 <525ff263-90b3-5b12-da31-171b09f9ad1b@daynix.com>
 <87h6yeta8b.wl-maz@kernel.org>
 <d54e7e38-cdf6-ef5d-a6e6-e30ad8a59034@gmail.com>
 <87bkojtdvy.wl-maz@kernel.org>
From: Akihiko Odaki <akihiko.odaki@daynix.com>
In-Reply-To: <87bkojtdvy.wl-maz@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Message-ID: <20221211052531.N3zqiupgcVuYJ7121jG_sMY_irtQav_MLTBSVgWc83Y@z>

On 2022/12/04 23:57, Marc Zyngier wrote:
> On Fri, 02 Dec 2022 09:55:24 +0000,
> Akihiko Odaki <akihiko.odaki@gmail.com> wrote:
>>
>> On 2022/12/02 18:40, Marc Zyngier wrote:
>>> On Fri, 02 Dec 2022 05:17:12 +0000,
>>> Akihiko Odaki <akihiko.odaki@daynix.com> wrote:
>>>>
>>>>>> On M2 MacBook Air, I have seen no other difference in standard ID
>>>>>> registers and CCSIDRs are exceptions. Perhaps Apple designed this way
>>>>>> so that macOS's Hypervisor can freely migrate vCPU, but I can't assure
>>>>>> that without more analysis. This is still enough to migrate vCPU
>>>>>> running Linux at least.
>>>>>
>>>>> I guess that MacOS hides more of the underlying HW than KVM does. And
>>>>> KVM definitely doesn't hide the MIDR_EL1 registers, which *are*
>>>>> different between the two clusters.
>>>>
>>>> It seems KVM stores a MIDR value of a CPU and reuse it as "invariant"
>>>> value for ioctls while it exposes the MIDR value each physical CPU
>>>> owns to vCPU.
>>>
>>> This only affects the VMM though, and not the guest which sees the
>>> MIDR of the CPU it runs on. The problem is that at short of pinning
>>> the vcpus, you don't know where they will run. So any value is fair
>>> game.
>>
>> Yes, my concern is that VMM can be confused if it sees something
>> different from what the guest on the vCPU sees.
> 
> Well, this has been part of the ABI for about 10 years, since Rusty
> introduced this notion of invariant, so userspace is already working
> around it if that's an actual issue.

In that case, I think it is better to document that the interface is not 
working properly and deprecated.

> 
> This would be easily addressed though, and shouldn't result in any
> issue. The following should do the trick (only lightly tested on an
> M1).

This can be problematic when restoring vcpu state saved with the old 
kernel. A possible solution is to allow the userspace to overwrite 
MIDR_EL1 as proposed for CCSIDR_EL1.

Regards,
Akihiko Odaki

> 
> Thanks,
> 
> 	M.
> 
>  From f1caacb89eb8ae40dc38669160a2f081f87f4b15 Mon Sep 17 00:00:00 2001
> From: Marc Zyngier <maz@kernel.org>
> Date: Sun, 4 Dec 2022 14:22:22 +0000
> Subject: [PATCH] KVM: arm64: Return MIDR_EL1 to userspace as seen on the vcpu
>   thread
> 
> When booting, KVM sample the MIDR of the CPU it initialises on,
> and keep this as the value that will forever be exposed to userspace.
> 
> However, this has nothing to do with the value that the guest will
> see. On an asymetric system, this can result in userspace observing
> weird things, specially if it has pinned the vcpus on a *different*
> set of CPUs.
> 
> Instead, return the MIDR value for the vpcu we're currently on and
> that the vcpu will observe if it has been pinned onto that CPU.
> 
> For symmetric systems, this changes nothing. For asymmetric machines,
> they will observe the correct MIDR value at the point of the call.
> 
> Reported-by: Akihiko Odaki <akihiko.odaki@gmail.com>
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>   arch/arm64/kvm/sys_regs.c | 19 +++++++++++++++++--
>   1 file changed, 17 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> index f4a7c5abcbca..f6bcf8ba9b2e 100644
> --- a/arch/arm64/kvm/sys_regs.c
> +++ b/arch/arm64/kvm/sys_regs.c
> @@ -1246,6 +1246,22 @@ static int set_id_reg(struct kvm_vcpu *vcpu, const struct sys_reg_desc *rd,
>   	return 0;
>   }
>   
> +static int get_midr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *rd,
> +		    u64 *val)
> +{
> +	*val = read_sysreg(midr_el1);
> +	return 0;
> +}
> +
> +static int set_midr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *rd,
> +		    u64 val)
> +{
> +	if (val != read_sysreg(midr_el1))
> +		return -EINVAL;
> +
> +	return 0;
> +}
> +
>   static int get_raz_reg(struct kvm_vcpu *vcpu, const struct sys_reg_desc *rd,
>   		       u64 *val)
>   {
> @@ -1432,6 +1448,7 @@ static const struct sys_reg_desc sys_reg_descs[] = {
>   
>   	{ SYS_DESC(SYS_DBGVCR32_EL2), NULL, reset_val, DBGVCR32_EL2, 0 },
>   
> +	{ SYS_DESC(SYS_MIDR_EL1), .get_user = get_midr, .set_user = set_midr },
>   	{ SYS_DESC(SYS_MPIDR_EL1), NULL, reset_mpidr, MPIDR_EL1 },
>   
>   	/*
> @@ -2609,7 +2626,6 @@ id_to_sys_reg_desc(struct kvm_vcpu *vcpu, u64 id,
>   		((struct sys_reg_desc *)r)->val = read_sysreg(reg);	\
>   	}
>   
> -FUNCTION_INVARIANT(midr_el1)
>   FUNCTION_INVARIANT(revidr_el1)
>   FUNCTION_INVARIANT(clidr_el1)
>   FUNCTION_INVARIANT(aidr_el1)
> @@ -2621,7 +2637,6 @@ static void get_ctr_el0(struct kvm_vcpu *v, const struct sys_reg_desc *r)
>   
>   /* ->val is filled in by kvm_sys_reg_table_init() */
>   static struct sys_reg_desc invariant_sys_regs[] = {
> -	{ SYS_DESC(SYS_MIDR_EL1), NULL, get_midr_el1 },
>   	{ SYS_DESC(SYS_REVIDR_EL1), NULL, get_revidr_el1 },
>   	{ SYS_DESC(SYS_CLIDR_EL1), NULL, get_clidr_el1 },
>   	{ SYS_DESC(SYS_AIDR_EL1), NULL, get_aidr_el1 },
