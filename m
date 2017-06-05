From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: Vexpress TC2 no longer booting on v4.12-rc1
Date: Mon, 5 Jun 2017 10:27:05 +0100
Message-ID: <6527c326-f4fc-8b37-21c8-ee7e361d9f63@arm.com>
References: <CANLsYkz3dcVArStN2GJguYfJbWc_4dC4vvTE1KVtYpVWipEYjg@mail.gmail.com>
 <a8b9336e-661a-841a-ca93-45ebe1b55994@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <a8b9336e-661a-841a-ca93-45ebe1b55994@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Sudeep Holla <sudeep.holla@arm.com>, Mathieu Poirier <mathieu.poirier@linaro.org>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>, Catalin Marinas <catalin.marinas@arm.com>, Christoffer Dall <cdall@linaro.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On 05/06/17 10:18, Sudeep Holla wrote:
> 
> 
> On 02/06/17 23:16, Mathieu Poirier wrote:
>> Good afternoon Russell and friends,
>>
>> I noticed that my vexpress-TC2 platform stopped booting when moving to
>> kernel v4.12-rc1 (same with -rc2 and 3).  The last time things worked
>> properly was on v4.11.  I did a bisect between v4.11 and v4.12-rc1 and
>> ended up on [1], hence this email.
>>
>> Since CONFIG_ARM_VIRT_EXT is selected by  default I removed the
>> "#ifdef CONFIG_ARM_VIRT_EXT" section in the last hunk of the patch and
>> the system sprung up to life again.
>>
>> Compiler: arm-linux-gnueabi-gcc (Ubuntu/Linaro 5.4.0-6ubuntu1~16.04.4)
>> 5.4.0 20160609
>> Kernel command line: console=ttyAMA0,38400 loglevel=8 root=/dev/sda2 rootwait
>> U-boot:
>>  ## Flattened Device Tree blob at 82000000
>>    Booting using the fdt blob at 0x82000000
>>    Loading Ramdisk to 9fcea000, end 9feea6d1 ... OK
>>    Loading Device Tree to 9fce2000, end 9fce9ad8 ... OK
>>
>> I'm not sure what else you need at this time - simply get back to me
>> with what I'm missing and I'll be happy to provided.  I'm also
>> offering to test patches.
>>
> 
> Fixed[1] and must be queued in rmk's tree[2].

Ah, brilliant. Thanks Sudeep.

	M.
-- 
Jazz is not dead. It just smells funny...
