Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B6F71ED32
	for <kvmarm@lists.linux.dev>; Tue, 25 Jul 2023 10:24:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1690280655; x=1721816655;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=z2JgSRr57QfGjyG/fWEsaikXL6iwmaxUOjUdDAVtI0A=;
  b=Fercbqa/NHlP22hLnpnAp2R+FGU9Rh3sUgLKrpCXCqlnDtIe+ixiyC9d
   vO3Uonae5QkevnklPMkZyYYw/FVGmYumnyRUN92plX0vlQTs+uknawrNY
   Q672eQkWkN0T0sQ1CsKA1xLWUfVxvOBpldso9PiBT5eL3Fb9D4hhzlGiy
   VAkuyawxZrXSGaR1uD/u4ugHMt+BgEWlI0IyPqtpREk+sgJtoUYCVZ9HP
   aN4/DB2K2R9ZBnelvletiHMQHdfo7scDzXDWmnNZ7JinNedm3USNo9D+n
   hYPXp6WyRiViI7I2L5B/CbfNI6hkjhMO8IGfcGtaBP674VBv2PE9KNT6n
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10781"; a="347956814"
X-IronPort-AV: E=Sophos;i="6.01,230,1684825200"; 
   d="scan'208";a="347956814"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jul 2023 03:24:13 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10781"; a="1056753039"
X-IronPort-AV: E=Sophos;i="6.01,230,1684825200"; 
   d="scan'208";a="1056753039"
Received: from mlytkin-mobl2.ger.corp.intel.com (HELO box.shutemov.name) ([10.252.57.129])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jul 2023 03:24:05 -0700
Received: by box.shutemov.name (Postfix, from userid 1000)
	id 171E4103A12; Tue, 25 Jul 2023 13:24:03 +0300 (+03)
Date: Tue, 25 Jul 2023 13:24:03 +0300
From: "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>
To: Sean Christopherson <seanjc@google.com>,
	Vlastimil Babka <vbabka@suse.cz>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>,
	Huacai Chen <chenhuacai@kernel.org>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Anup Patel <anup@brainfault.org>,
	Paul Walmsley <paul.walmsley@sifive.com>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Albert Ou <aou@eecs.berkeley.edu>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Paul Moore <paul@paul-moore.com>, James Morris <jmorris@namei.org>,
	"Serge E. Hallyn" <serge@hallyn.com>, kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	linux-mips@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
	kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org,
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
	linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
	Chao Peng <chao.p.peng@linux.intel.com>,
	Fuad Tabba <tabba@google.com>, Jarkko Sakkinen <jarkko@kernel.org>,
	Yu Zhang <yu.c.zhang@linux.intel.com>,
	Vishal Annapurve <vannapurve@google.com>,
	Ackerley Tng <ackerleytng@google.com>,
	Maciej Szmigiero <mail@maciej.szmigiero.name>,
	David Hildenbrand <david@redhat.com>,
	Quentin Perret <qperret@google.com>,
	Michael Roth <michael.roth@amd.com>, Wang <wei.w.wang@intel.com>,
	Liam Merwick <liam.merwick@oracle.com>,
	Isaku Yamahata <isaku.yamahata@gmail.com>
Subject: Re: [RFC PATCH v11 10/29] mm: Add AS_UNMOVABLE to mark mapping as
 completely unmovable
Message-ID: <20230725102403.xywjqlhyqkrzjok6@box.shutemov.name>
References: <20230718234512.1690985-1-seanjc@google.com>
 <20230718234512.1690985-11-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230718234512.1690985-11-seanjc@google.com>

On Tue, Jul 18, 2023 at 04:44:53PM -0700, Sean Christopherson wrote:
> diff --git a/mm/compaction.c b/mm/compaction.c
> index dbc9f86b1934..a3d2b132df52 100644
> --- a/mm/compaction.c
> +++ b/mm/compaction.c
> @@ -1047,6 +1047,10 @@ isolate_migratepages_block(struct compact_control *cc, unsigned long low_pfn,
>  		if (!mapping && (folio_ref_count(folio) - 1) > folio_mapcount(folio))
>  			goto isolate_fail_put;
>  
> +		/* The mapping truly isn't movable. */
> +		if (mapping && mapping_unmovable(mapping))
> +			goto isolate_fail_put;
> +

I doubt that it is safe to dereference mapping here. I believe the folio
can be truncated from under us and the mapping freed with the inode.

The folio has to be locked to dereference mapping safely (given that the
mapping is still tied to the folio).

Vlastimil, any comments?

-- 
  Kiryl Shutsemau / Kirill A. Shutemov
