From: Alex =?utf-8?Q?Benn=C3=A9e?= <alex.bennee@linaro.org>
Subject: Re: [Qemu-devel] [PATCH kvm-unit-tests v8 00/10] arm/arm64: add gic framework
Date: Wed, 14 Dec 2016 15:36:01 +0000
Message-ID: <871sxattem.fsf@linaro.org>
References: <20161208175030.12269-1-drjones@redhat.com> <20161214134644.4jm4sfv42jai732o@kamzik.brq.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <kvm-owner@vger.kernel.org>
In-reply-to: <20161214134644.4jm4sfv42jai732o@kamzik.brq.redhat.com>
Sender: kvm-owner@vger.kernel.org
To: Andrew Jones <drjones@redhat.com>
Cc: kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, qemu-devel@nongnu.org, qemu-arm@nongnu.org, peter.maydell@linaro.org, marc.zyngier@arm.com, andre.przywara@arm.com, eric.auger@redhat.com, pbonzini@redhat.com, christoffer.dall@linaro.org
List-Id: kvmarm@lists.cs.columbia.edu


Andrew Jones <drjones@redhat.com> writes:

> On Thu, Dec 08, 2016 at 06:50:20PM +0100, Andrew Jones wrote:
>>
>> v8:
>>  - Main change is rebasing to Wei's sysreg framework, which is part
>>    of his PMU series, which I've applied to arm/next. That rebase
>>    leads to dropping the first two patches of the v7 series, expecting
>>    get_mpidr() to return u64 (with future patches), a rework of the
>>    delay routines (now based on sysreg framework), and changes to all
>>    sysreg asms
>>  - The delay routines also got their own files: delay.[ch]
>>  - Another bigger change was to now keep gic_common_ops local to
>>    lib/arm/gic.c, export the functions from the gic-v[23] instead
>>  - Yet another bigger change was dropping the sender and irq cmdline
>>    inputs, hard coding to '1' is sufficient and much less code
>>  - Other minor changes listed in individual patches
>>
>
> OK, I'm going to go ahead and apply this to arm/next. Before making
> the pull request I'll post another series that includes the 64-bit
> MPIDR fix that Andre pointed out we need, and a couple other fixes,
> though. Assuming nobody complains about that series, then I'll fold
> those patches into arm/next too and make the pull request.

All looks good for me. I'll be re-basing my TCG tests once upstream has
these changes merged.

--
Alex Bennée
