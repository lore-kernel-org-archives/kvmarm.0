From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH v2 2/5] arm64: Work around Falkor erratum 1003
Date: Wed, 4 Jan 2017 11:33:22 +0100
Message-ID: <20170104103322.GA20461@cbox>
References: <20161229224335.13531-1-cov@codeaurora.org>
 <20161229224335.13531-2-cov@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 677B8403FB
 for <kvmarm@lists.cs.columbia.edu>; Wed,  4 Jan 2017 05:31:50 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id AWQTnpGsbNOV for <kvmarm@lists.cs.columbia.edu>;
 Wed,  4 Jan 2017 05:31:49 -0500 (EST)
Received: from mail-lf0-f48.google.com (mail-lf0-f48.google.com
 [209.85.215.48])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 0B877400E9
 for <kvmarm@lists.cs.columbia.edu>; Wed,  4 Jan 2017 05:31:48 -0500 (EST)
Received: by mail-lf0-f48.google.com with SMTP id b14so301864949lfg.2
 for <kvmarm@lists.cs.columbia.edu>; Wed, 04 Jan 2017 02:33:23 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <20161229224335.13531-2-cov@codeaurora.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Christopher Covington <cov@codeaurora.org>
Cc: linux-doc@vger.kernel.org, kvm@vger.kernel.org, Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, timur@codeaurora.org, Jonathan Corbet <corbet@lwn.net>, Will Deacon <will.deacon@arm.com>, linux-kernel@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Thu, Dec 29, 2016 at 05:43:32PM -0500, Christopher Covington wrote:
> From: Shanker Donthineni <shankerd@codeaurora.org>
> 
> On the Qualcomm Datacenter Technologies Falkor v1 CPU, memory accesses may
> allocate TLB entries using an incorrect ASID when TTBRx_EL1 is being
> updated. Changing the TTBRx_EL1[ASID] and TTBRx_EL1[BADDR] fields
> separately using a reserved ASID will ensure that there are no TLB entries
> with incorrect ASID after changing the the ASID.

When we restore guest state in KVM, we completely save and restore
TTBRx_EL1 from EL2. Would that be affected by this erratum?

Thanks,
-Christoffer
