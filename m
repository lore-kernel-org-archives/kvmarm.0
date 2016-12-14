From: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH 1/1] arm64: Correcting format specifier for printing 64
 bit addresses
Date: Wed, 14 Dec 2016 17:35:53 +0100
Message-ID: <65935935-bdd9-c6a6-1a33-2bbaf6ffbbc5@redhat.com>
References: <1480925393-8386-1-git-send-email-maninder1.s@samsung.com>
 <20161206161116.GD4816@cbox>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E461340457
 for <kvmarm@lists.cs.columbia.edu>; Wed, 14 Dec 2016 11:34:55 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 4kufA2qs56M7 for <kvmarm@lists.cs.columbia.edu>;
 Wed, 14 Dec 2016 11:34:53 -0500 (EST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id D3C684044B
 for <kvmarm@lists.cs.columbia.edu>; Wed, 14 Dec 2016 11:34:53 -0500 (EST)
In-Reply-To: <20161206161116.GD4816@cbox>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Christoffer Dall <christoffer.dall@linaro.org>, Maninder Singh <maninder1.s@samsung.com>
Cc: wangkefeng.wang@huawei.com, kvm@vger.kernel.org, catalin.marinas@arm.com, will.deacon@arm.com, kvmarm@lists.cs.columbia.edu, panand@redhat.com, cpgs@samsung.com, shijie.huang@arm.com, labbott@redhat.com, Vaneet Narang <v.narang@samsung.com>, cmetcalf@mellanox.com, marc.zyngier@arm.com, ajeet.y@samsung.com, sandeepa.s.prabhu@gmail.com, linux-arm-kernel@lists.infradead.org, pankaj.m@samsung.com, ard.biesheuvel@linaro.org, linux-kernel@vger.kernel.org, akpm@linux-foundation.org
List-Id: kvmarm@lists.cs.columbia.edu



On 06/12/2016 17:11, Christoffer Dall wrote:
> +		kvm_err("Unsupported guest CP%d access at: %08lx\n",
> +			cp, *vcpu_pc(vcpu));
> +	else
> +		kvm_err("Unsupported guest CP%d access at: %016lx\n",
> +			cp, *vcpu_pc(vcpu));
> 
> It feels a bit much to me to have an if-statement to differentiate the
> number of leading zeros, so if it's important to always have fixed
> widths then I would just use %016lx in both cases.

Really, this is just a debugging message.  Just use "0x%lx" and let's
stop bikeshedding. :)

Paolo
