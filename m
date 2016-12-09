From: Peter Maydell <peter.maydell@linaro.org>
Subject: Re: [PATCH kvm-unit-tests v2 2/2] arm/pmu: don't run tcg tests
Date: Fri, 9 Dec 2016 17:33:17 +0000
Message-ID: <CAFEAcA_GtiyVNwGbFKykPjwYNRbupe2xLYpFOjZA25JGUuxbtQ@mail.gmail.com>
References: <20161208170549.8793-1-drjones@redhat.com> <20161208170549.8793-3-drjones@redhat.com>
 <dd08b360-a0e9-1d98-a703-c54adb50e4a2@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <dd08b360-a0e9-1d98-a703-c54adb50e4a2@codeaurora.org>
Sender: kvm-owner@vger.kernel.org
To: Christopher Covington <cov@codeaurora.org>
Cc: Andrew Jones <drjones@redhat.com>, kvm-devel <kvm@vger.kernel.org>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, Andre Przywara <andre.przywara@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

On 9 December 2016 at 17:22, Christopher Covington <cov@codeaurora.org> wrote:
> On 12/08/2016 12:05 PM, Andrew Jones wrote:
>> The TCG PMU is barely implemented for ARM and not at all implemented
>> for AArch64. Let's not bother running the TCG-only tests yet. We'll
>> likely move them to a new TCG-only unittests.cfg at some point before
>> re-enabling them too.
>
> ID_AA64DFR0_EL1 isn't implemented in TCG, which should be first fixed
> and then tested. I think and hope we're in agreement on that.

Hmm? We have
            { .name = "ID_AA64DFR0_EL1", .state = ARM_CP_STATE_AA64,
              .opc0 = 3, .opc1 = 0, .crn = 0, .crm = 5, .opc2 = 0,
              .access = PL1_R, .type = ARM_CP_CONST,
              /* We mask out the PMUVer field, because we don't currently
               * implement the PMU. Not advertising it prevents the guest
               * from trying to use it and getting UNDEFs on registers we
               * don't implement.
               */
              .resetvalue = cpu->id_aa64dfr0 & ~0xf00 },

which strongly suggests that we implement it... is that buggy somehow?

thanks
-- PMM
