From: James Morse <james.morse@arm.com>
Subject: Re: [PATCH v4 6/6] arm/kvm: arm64: Add a vcpu feature for pointer
 authentication
Date: Fri, 4 Jan 2019 17:59:27 +0000
Message-ID: <1d5f5167-8606-3bda-a195-b962c99eb196@arm.com>
References: <1545119810-12182-1-git-send-email-amit.kachhap@arm.com>
 <1545119810-12182-7-git-send-email-amit.kachhap@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1545119810-12182-7-git-send-email-amit.kachhap@arm.com>
Content-Language: en-GB
Sender: linux-kernel-owner@vger.kernel.org
To: Amit Daniel Kachhap <amit.kachhap@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Kristina Martsenko <kristina.martsenko@arm.com>, kvmarm@lists.cs.columbia.edu, Ramana Radhakrishnan <ramana.radhakrishnan@arm.com>, Dave Martin <Dave.Martin@arm.com>, linux-kernel@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

Hi Amit,

On 18/12/2018 07:56, Amit Daniel Kachhap wrote:
> This is a runtime feature and can be enabled by --ptrauth option.

It took me a little while to realise this was a kvmtool patch. could you put
something in the patch-subject to make this obvious? e.g:
https://lists.cs.columbia.edu/pipermail/kvmarm/2018-September/thread.html#32734


Thanks,

James
