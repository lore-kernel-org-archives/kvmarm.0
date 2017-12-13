From: Catalin Marinas <catalin.marinas@arm.com>
Subject: Re: [PATCH 05/12] arm64: mm: Remove VMALLOC checks from
 update_mapping_prot(.)
Date: Wed, 13 Dec 2017 16:04:32 +0000
Message-ID: <20171213160431.vlasctskuwmkm6xh@armageddon.cambridge.arm.com>
References: <20171204141313.31604-1-steve.capper@arm.com>
 <20171204141313.31604-6-steve.capper@arm.com>
 <CAKv+Gu80J1vGn6V6Z3eXajDos=sjY_fLhUQP=-n0A8MyunTfgQ@mail.gmail.com>
 <20171212153923.a7z6kcowxj7thljy@capper-debian.cambridge.arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E983249D73
 for <kvmarm@lists.cs.columbia.edu>; Wed, 13 Dec 2017 11:01:05 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id IjU3J-n8hjg1 for <kvmarm@lists.cs.columbia.edu>;
 Wed, 13 Dec 2017 11:01:05 -0500 (EST)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C777149DA0
 for <kvmarm@lists.cs.columbia.edu>; Wed, 13 Dec 2017 11:01:04 -0500 (EST)
Content-Disposition: inline
In-Reply-To: <20171212153923.a7z6kcowxj7thljy@capper-debian.cambridge.arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Steve Capper <steve.capper@arm.com>
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>, takahiro.akashi@linaro.org, nd@arm.com, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>
List-Id: kvmarm@lists.cs.columbia.edu

On Tue, Dec 12, 2017 at 03:39:23PM +0000, Steve Capper wrote:
> It is not apparent to me how mark_linear_text_alias_ro(.) guarantees
> that no page table entries for the linear map are split, though.

map_mem() ensures that when mapped via __map_memblock(), no contiguous
entries are created. Also both ends of the _text..__init_begin would be
mapped to the granularity permitted by their alignment so that no later
splitting is necessary.

-- 
Catalin
