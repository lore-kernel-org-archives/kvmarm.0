From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: KVM on Snapdragon 810(arm64)
Date: Wed, 25 Nov 2015 08:05:27 +0000
Message-ID: <20151125080527.79b256ed@arm.com>
References: <CAE6JOJ8L7+Fh-JEvXKhBnDPmGBLxMO8U1vJPoWd8WXU+Ogr5og@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-msm-owner@vger.kernel.org>
In-Reply-To: <CAE6JOJ8L7+Fh-JEvXKhBnDPmGBLxMO8U1vJPoWd8WXU+Ogr5og@mail.gmail.com>
Sender: linux-arm-msm-owner@vger.kernel.org
To: "sk.syed2" <sk.syed2@gmail.com>
Cc: kvmarm@lists.cs.columbia.edu, linux-arm-msm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

On Wed, 25 Nov 2015 02:01:57 +0530
"sk.syed2" <sk.syed2@gmail.com> wrote:

> Hello
>    Has anyone tried to run KVM on arm64/Snapdragon platform. I am
> trying to run KVM on snapdragon 810/msm8994 platform. What is the
> stable kernel release which supports this?
> Sorry couldn't  find this information from the archives.

I don't think anyone tried.

My only experience with QC hardware (Snapdragon 410) is that the (non
replaceable) firmware drops you at EL1-NS, annihilating any chance of
running KVM (or any other hypervisor) on this HW.

I wish Snapdragon 810 was different, but I haven't seen any sign of
that so far.

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny.
