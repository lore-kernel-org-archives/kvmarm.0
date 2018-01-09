From: Catalin Marinas <catalin.marinas@arm.com>
Subject: Re: [PATCH] arm64: Implement branch predictor hardening for Falkor
Date: Tue, 9 Jan 2018 11:05:47 +0000
Message-ID: <20180109110547.ok35kw5e4rwicnf3@localhost>
References: <1515184139-23743-1-git-send-email-shankerd@codeaurora.org>
 <20180108170933.GU25869@arm.com>
 <20180108184446.GC13175@arm.com>
 <01fe1f41-ac45-0c19-a502-77b915c48fcf@codeaurora.org>
 <fa96f638-075e-10a0-d764-9c24b50fcf13@codeaurora.org>
 <20180109094146.GB4297@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180109094146.GB4297@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Will Deacon <will.deacon@arm.com>
Cc: Shanker Donthineni <shankerd@codeaurora.org>, Vikram Sethi <vikrams@codeaurora.org>, Sean Campbell <scampbel@codeaurora.org>, Marc Zyngier <marc.zyngier@arm.com>, linux-kernel <linux-kernel@vger.kernel.org>, Christoffer Dall <christoffer.dall@linaro.org>, kvmarm <kvmarm@lists.cs.columbia.edu>, linux-arm-kernel <linux-arm-kernel@lists.infradead.org>
List-Id: kvmarm@lists.cs.columbia.edu

On Tue, Jan 09, 2018 at 09:41:46AM +0000, Will Deacon wrote:
> You'll need to send a fixup patch. for-next/core is non-rebasing.

I haven't pushed it out yet (will do this morning) but note that
for-next/core is based on 4.15-rc3.

-- 
Catalin
