From: Timur Tabi <timur@codeaurora.org>
Subject: Re: [PATCH] arm64/kvm: Add generic v8 KVM target
Date: Fri, 19 Jun 2015 15:31:27 -0500
Message-ID: <55847C1F.1090606@codeaurora.org>
References: <1434531646-4873-1-git-send-email-suzuki.poulose@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <1434531646-4873-1-git-send-email-suzuki.poulose@arm.com>
Sender: kvm-owner@vger.kernel.org
To: "Suzuki K. Poulose" <suzuki.poulose@arm.com>, linux-arm-kernel@lists.infradead.org
Cc: christoffer.dall@linaro.org, Marc.Zyngier@arm.com, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, shankerd@codeaurora.org, vgandhi@codeaurora.org
List-Id: kvmarm@lists.cs.columbia.edu

On 06/17/2015 04:00 AM, Suzuki K. Poulose wrote:
>   					  &genericv8_target_table);
>   	kvm_register_target_sys_reg_table(KVM_ARM_TARGET_XGENE_POTENZA,
>   					  &genericv8_target_table);
> +	kvm_register_target_sys_reg_table(KVM_ARM_TARGET_GENERIC_V8,
> +					  &genericv8_target_table);
>

Shouldn't you also remove all of the previous lines that return 
&genericv8_target_table?

-- 
Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the
Code Aurora Forum, a Linux Foundation Collaborative Project.
--
To unsubscribe from this list: send the line "unsubscribe kvm" in
