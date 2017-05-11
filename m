From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH v1 2/2] KVM: arm: rename pm_fake handler to trap_raz_wi
Date: Thu, 11 May 2017 08:40:28 +0100
Message-ID: <abe33184-df28-2604-23db-ef4cdd3a9da7@arm.com>
References: <20170510170200.13285-1-alex.bennee@linaro.org>
 <20170510170200.13285-3-alex.bennee@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170510170200.13285-3-alex.bennee@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
To: =?UTF-8?Q?Alex_Benn=c3=a9e?= <alex.bennee@linaro.org>, christoffer.dall@linaro.org
Cc: kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, Zhichao Huang <zhichao.huang@linaro.org>, Paolo Bonzini <pbonzini@redhat.com>, =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>, Russell King <linux@armlinux.org.uk>, open list <linux-kernel@vger.kernel.org>
List-Id: kvmarm@lists.cs.columbia.edu

On 10/05/17 18:01, Alex Bennée wrote:
> From: Zhichao Huang <zhichao.huang@linaro.org>
> 
> pm_fake doesn't quite describe what the handler does (ignoring writes
> and returning 0 for reads).
> 
> As we're about to use it (a lot) in a different context, rename it
> with a (admitedly cryptic) name that make sense for all users.
> 
> Signed-off-by: Zhichao Huang <zhichao.huang@linaro.org>
> Reviewed-by: Alex Bennee <alex.bennee@linaro.org>
> Acked-by: Christoffer Dall <christoffer.dall@linaro.org>
> Signed-off-by: Alex Bennée <alex.bennee@linaro.org>

Acked-by: Marc Zyngier <marc.zyngier@arm.com>

	M.
-- 
Jazz is not dead. It just smells funny...
