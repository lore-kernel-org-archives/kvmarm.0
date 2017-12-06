From: gengdongjiu <gengdongjiu@huawei.com>
Subject: Re: [PATCH v8 7/7] arm64: kvm: handle SError Interrupt by
 categorization
Date: Wed, 6 Dec 2017 18:26:14 +0800
Message-ID: <4af78739-99da-4056-4db1-f80bfe11081a@huawei.com>
References: <1510343650-23659-1-git-send-email-gengdongjiu@huawei.com>
 <1510343650-23659-8-git-send-email-gengdongjiu@huawei.com>
 <5A0B1334.7060500@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Return-path: <linux-acpi-owner@vger.kernel.org>
In-Reply-To: <5A0B1334.7060500@arm.com>
Content-Language: en-US
Sender: linux-acpi-owner@vger.kernel.org
To: James Morse <james.morse@arm.com>
Cc: christoffer.dall@linaro.org, marc.zyngier@arm.com, linux@armlinux.org.uk, bp@alien8.de, rjw@rjwysocki.net, pbonzini@redhat.com, rkrcmar@redhat.com, corbet@lwn.net, catalin.marinas@arm.com, kvm@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, linux-acpi@vger.kernel.org, devel@acpica.org, huangshaoyu@huawei.com, wuquanming@huawei.com, linuxarm@huawei.com
List-Id: kvmarm@lists.cs.columbia.edu


On 2017/11/15 0:00, James Morse wrote:
>> +		 * error has not been propagated
>> +		 */
>> +		run->exit_reason = KVM_EXIT_EXCEPTION;
>> +		run->ex.exception = ESR_ELx_EC_SERROR;
>> +		run->ex.error_code = KVM_SEI_SEV_RECOVERABLE;
>> +		return 0;
> We should not pass RAS notifications to user space. The kernel either handles
> them, or it panics(). User space shouldn't even know if the kernel supports RAS
> until it gets an MCEERR signal.
> 
> You're making your firmware-first notification an EL3->EL0 signal, bypassing the OS.
> 
> If we get a RAS SError and there are no CPER records or values in the ERR nodes,
> we should panic as it looks like the CPU/firmware is broken. (spurious RAS errors)

Hi james,
  sorry to disturb you!

  do you think whether we need to set the guest ESR by user space?  if need, I need to
notify user space that there is a SError happen and need to set ESR for guest in some place of
KVM. so here I return a error code to user space. you mean we should not pass RAS notifications
to user space, so could you give some suggestion how to notify user space to set guest ESR.

Thanks a lot in advance.


> 
> 

