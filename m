From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH kvm-unit-tests 2/3] arm64: timer: Fix test on APM X-Gene
Date: Fri, 14 Jul 2017 09:04:10 +0100
Message-ID: <a58bfe11-19a0-aa92-5166-2c33e4cb8981@arm.com>
References: <20170713192009.10069-1-cdall@linaro.org>
 <20170713192009.10069-3-cdall@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <20170713192009.10069-3-cdall@linaro.org>
Sender: kvm-owner@vger.kernel.org
To: Christoffer Dall <cdall@linaro.org>, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
Cc: Andrew Jones <drjones@redhat.com>, Alexander Graf <agraf@suse.de>, Paolo Bonzini <pbonzini@redhat.com>, =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>, Jintack Lim <jintack@cs.columbia.edu>
List-Id: kvmarm@lists.cs.columbia.edu

On 13/07/17 20:20, Christoffer Dall wrote:
> When running the vtimer test on an APM X-Gene, setting the timer value
> to (2^64 - 1) apparently results in the timer always firing, even
> thought the counter is mich lower than the cval.

Note that the system counter is only guaranteed to be at least 56 bit
wide (see DDI0487B.a G5.1.2), and I seem to remember that X-Gene only
has the minimum. This could explain why setting the comparator to a
value greater than (2^56 - 1) leads to a firing timer (the comparator
appears to be in the past).

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...
