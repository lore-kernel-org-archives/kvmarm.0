From: "sk.syed2" <sk.syed2@gmail.com>
Subject: Re: KVM on Snapdragon 810(arm64)
Date: Wed, 25 Nov 2015 21:16:49 +0530
Message-ID: <CAE6JOJ-SWpWFWT7ZSuFuzMqgoqnNPbYwvsmL-Lkxy-ntT7zcZA@mail.gmail.com>
References: <CAE6JOJ8L7+Fh-JEvXKhBnDPmGBLxMO8U1vJPoWd8WXU+Ogr5og@mail.gmail.com>
	<20151125080527.79b256ed@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-arm-msm-owner@vger.kernel.org>
In-Reply-To: <20151125080527.79b256ed@arm.com>
Sender: linux-arm-msm-owner@vger.kernel.org
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: kvmarm@lists.cs.columbia.edu, linux-arm-msm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

> I don't think anyone tried.
>
> My only experience with QC hardware (Snapdragon 410) is that the (non
> replaceable) firmware drops you at EL1-NS, annihilating any chance of
> running KVM (or any other hypervisor) on this HW.
>
> I wish Snapdragon 810 was different, but I haven't seen any sign of
> that so far.

Yes, same thing with 810.

-syed
