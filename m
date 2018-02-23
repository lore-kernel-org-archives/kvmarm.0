From: Julien Grall <julien.grall@arm.com>
Subject: Re: [PATCH v4 35/40] KVM: arm/arm64: Get rid of vgic_elrsr
Date: Fri, 23 Feb 2018 14:44:30 +0000
Message-ID: <b15dda97-a860-0ed5-79d0-4c011f7e3b84@arm.com>
References: <20180215210332.8648-1-christoffer.dall@linaro.org>
 <20180215210332.8648-36-christoffer.dall@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4DEDD40458
 for <kvmarm@lists.cs.columbia.edu>; Fri, 23 Feb 2018 09:38:12 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Y8Zb3G9tfdY4 for <kvmarm@lists.cs.columbia.edu>;
 Fri, 23 Feb 2018 09:37:51 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6DEA2402D6
 for <kvmarm@lists.cs.columbia.edu>; Fri, 23 Feb 2018 09:37:51 -0500 (EST)
In-Reply-To: <20180215210332.8648-36-christoffer.dall@linaro.org>
Content-Language: en-US
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Christoffer Dall <christoffer.dall@linaro.org>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
Cc: kvm@vger.kernel.org, Marc Zyngier <marc.zyngier@arm.com>, Yury Norov <ynorov@caviumnetworks.com>, Dave Martin <Dave.Martin@arm.com>, Shih-Wei Li <shihwei@cs.columbia.edu>
List-Id: kvmarm@lists.cs.columbia.edu

Hi Christoffer,

On 15/02/18 21:03, Christoffer Dall wrote:
> There is really no need to store the vgic_elrsr on the VGIC data
> structures as the only need we have for the elrsr is to figure out if an
> LR is inactive when we save the VGIC state upon returning from the
> guest.  We can might as well store this in a temporary local variable.
> 
> This also gets rid of the endianness conversion in the VGIC save
> function, which is completely unnecessary and would actually result in
> incorrect functionality on big-endian systems, because we are only using
> typed values here and not converting pointers and reading different
> types here.

I can't find any endianness code removed in this code. What did I miss?

Cheers,

-- 
Julien Grall
