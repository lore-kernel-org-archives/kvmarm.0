From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH v3 05/22] arm64: KVM: Implement vgic-v3 save/restore
Date: Tue, 8 Dec 2015 08:19:31 +0000
Message-ID: <20151208081931.23def99d@why.wild-wind.fr.eu.org>
References: <1449485618-9443-1-git-send-email-marc.zyngier@arm.com>
	<1449485618-9443-6-git-send-email-marc.zyngier@arm.com>
	<5665B663.8020705@samsung.com>
	<5665B940.7000601@arm.com>
	<5665BF4D.7090103@samsung.com>
	<5665C3C7.9010600@arm.com>
	<5665CA68.2000401@samsung.com>
	<5665CDDF.3090201@arm.com>
	<56663D0C.1070500@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <56663D0C.1070500@samsung.com>
Sender: kvm-owner@vger.kernel.org
To: Mario Smarduch <m.smarduch@samsung.com>
Cc: Christoffer Dall <christoffer.dall@linaro.org>, kvm@vger.kernel.org, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Catalin Marinas <catalin.marinas@arm.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Mon, 7 Dec 2015 18:14:36 -0800
Mario Smarduch <m.smarduch@samsung.com> wrote:

> 
> 
> On 12/7/2015 10:20 AM, Marc Zyngier wrote:
> > On 07/12/15 18:05, Mario Smarduch wrote:
> >>
> >>
> >> On 12/7/2015 9:37 AM, Marc Zyngier wrote:
> [...]
> >>>
> >>
> >> I was thinking something like 'current_lr[VGIC_V3_LR_INDEX(...)]'.
> > 
> > That doesn't change anything, the compiler is perfectly able to 
> > optimize something like this:
> > 
> > [...]
> > ffffffc0007f31ac:       38624862        ldrb    w2, [x3,w2,uxtw]
> > ffffffc0007f31b0:       10000063        adr     x3, ffffffc0007f31bc <__vgic_v3_save_state+0x64>
> > ffffffc0007f31b4:       8b228862        add     x2, x3, w2, sxtb #2
> > ffffffc0007f31b8:       d61f0040        br      x2
> > ffffffc0007f31bc:       d53ccde2        mrs     x2, s3_4_c12_c13_7
> > ffffffc0007f31c0:       f9001c02        str     x2, [x0,#56]
> > ffffffc0007f31c4:       d53ccdc2        mrs     x2, s3_4_c12_c13_6
> > ffffffc0007f31c8:       f9002002        str     x2, [x0,#64]
> > ffffffc0007f31cc:       d53ccda2        mrs     x2, s3_4_c12_c13_5
> > ffffffc0007f31d0:       f9002402        str     x2, [x0,#72]
> > ffffffc0007f31d4:       d53ccd82        mrs     x2, s3_4_c12_c13_4
> > ffffffc0007f31d8:       f9002802        str     x2, [x0,#80]
> > ffffffc0007f31dc:       d53ccd62        mrs     x2, s3_4_c12_c13_3
> > ffffffc0007f31e0:       f9002c02        str     x2, [x0,#88]
> > ffffffc0007f31e4:       d53ccd42        mrs     x2, s3_4_c12_c13_2
> > ffffffc0007f31e8:       f9003002        str     x2, [x0,#96]
> > ffffffc0007f31ec:       d53ccd22        mrs     x2, s3_4_c12_c13_1
> > ffffffc0007f31f0:       f9003402        str     x2, [x0,#104]
> > ffffffc0007f31f4:       d53ccd02        mrs     x2, s3_4_c12_c13_0
> > ffffffc0007f31f8:       f9003802        str     x2, [x0,#112]
> > ffffffc0007f31fc:       d53ccce2        mrs     x2, s3_4_c12_c12_7
> > ffffffc0007f3200:       f9003c02        str     x2, [x0,#120]
> > ffffffc0007f3204:       d53cccc2        mrs     x2, s3_4_c12_c12_6
> > ffffffc0007f3208:       f9004002        str     x2, [x0,#128]
> > ffffffc0007f320c:       d53ccca2        mrs     x2, s3_4_c12_c12_5
> > ffffffc0007f3210:       f9004402        str     x2, [x0,#136]
> > ffffffc0007f3214:       d53ccc82        mrs     x2, s3_4_c12_c12_4
> > ffffffc0007f3218:       f9004802        str     x2, [x0,#144]
> > ffffffc0007f321c:       d53ccc62        mrs     x2, s3_4_c12_c12_3
> > ffffffc0007f3220:       f9004c02        str     x2, [x0,#152]
> > ffffffc0007f3224:       d53ccc42        mrs     x2, s3_4_c12_c12_2
> > ffffffc0007f3228:       f9005002        str     x2, [x0,#160]
> > ffffffc0007f322c:       d53ccc22        mrs     x2, s3_4_c12_c12_1
> > ffffffc0007f3230:       f9005402        str     x2, [x0,#168]
> > ffffffc0007f3234:       d53ccc02        mrs     x2, s3_4_c12_c12_0
> > ffffffc0007f3238:       7100183f        cmp     w1, #0x6
> > ffffffc0007f323c:       f9005802        str     x2, [x0,#176]
> > 
> > As you can see, this is as optimal as it gets, short of being able
> > to find a nice way to use more than one register...
> 
> Interesting, thanks for the dump I'm no expert on pipeline optimizations but I'm
> wondering with these system register accesses can these be executed out of order
> provided you didn't have what I thinks are write after read dependencies?

System-register reads can be executed out of order, that is not a
problem. Even the stores can be executed out of order as the CPU
renames the GP registers (depending on the microarchitecture, of
course).

Now, what I'd *really* like to see is GCC to output something similar
to what we have in the original code, where we use as many registers as
possible to store the data, and output it in one go, possibly using
strp. So far, I haven't found a way to convince the compiler to do so.

> It's only 4 registers here, there are some other longer stretches in subsequent
> patches.
> 
> I minor note here is some white space in this patch.

Ah, thanks for letting me know. I'll chase those.

Thanks,

	M.
-- 
Without deviation from the norm, progress is not possible.
