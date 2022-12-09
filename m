Received: from out2.migadu.com (out2.migadu.com [188.165.223.204])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDB0763C5
	for <kvmarm@lists.linux.dev>; Fri,  9 Dec 2022 17:32:03 +0000 (UTC)
Date: Fri, 9 Dec 2022 17:31:53 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1670607121;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Quc9rtPvjsg9ew9MEiiQXhgVWUDAsktBrFeTkewNKkw=;
	b=S3aITMWC9VbOiaYPYv282HLl69TTYT2DXs1taXC8F5AvLpueQkCZpRcqJJZ7MEQ/z1ikxk
	7SzK+vSIPm3olMNUfZjwywjGs/lA9BCHsEmRUTaRS9hVsFlgnqS/uvWtj6U8PgwtrWn919
	I22lC+tRKRHudvDQNy7Z+U+0R6DGNBs=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: David Matlack <dmatlack@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>,
	James Morse <james.morse@arm.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Huacai Chen <chenhuacai@kernel.org>,
	Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
	Anup Patel <anup@brainfault.org>,
	Atish Patra <atishp@atishpatra.org>,
	Paul Walmsley <paul.walmsley@sifive.com>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Albert Ou <aou@eecs.berkeley.edu>,
	Sean Christopherson <seanjc@google.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Anshuman Khandual <anshuman.khandual@arm.com>,
	Nadav Amit <namit@vmware.com>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Vlastimil Babka <vbabka@suse.cz>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Suren Baghdasaryan <surenb@google.com>,
	Peter Xu <peterx@redhat.com>, xu xin <cgel.zte@gmail.com>,
	Arnd Bergmann <arnd@arndb.de>, Yu Zhao <yuzhao@google.com>,
	Colin Cross <ccross@google.com>, Hugh Dickins <hughd@google.com>,
	Ben Gardon <bgardon@google.com>, Mingwei Zhang <mizhang@google.com>,
	Krish Sadhukhan <krish.sadhukhan@oracle.com>,
	Ricardo Koller <ricarkol@google.com>,
	Jing Zhang <jingzhangos@google.com>,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	kvmarm@lists.cs.columbia.edu, linux-mips@vger.kernel.org,
	kvm@vger.kernel.org, kvm-riscv@lists.infradead.org,
	linux-riscv@lists.infradead.org
Subject: Re: [RFC PATCH 23/37] KVM: MMU: Move VM-level TDP MMU state to
 struct kvm
Message-ID: <Y5NxCYz9XV3hgGYX@google.com>
References: <20221208193857.4090582-1-dmatlack@google.com>
 <20221208193857.4090582-24-dmatlack@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221208193857.4090582-24-dmatlack@google.com>
X-Migadu-Flow: FLOW_OUT
Message-ID: <20221209173153.NAhbovEnsmX3IePIN3J53A3BbtUPqet0iAVwTFfv6jQ@z>

Hey David,

On Thu, Dec 08, 2022 at 11:38:43AM -0800, David Matlack wrote:
> Move VM-level TDP MMU state to struct kvm so it can be accessed by
> common code in a future commit.
> 
> No functional change intended.

Could you instead introduce a structure to hold all of the MMU state and
stick that in struct kvm? If the goal is to eventually supersede all
uses of the arm64 pgtable library we are going to need the ability to
operate outside of a KVM VM context.

--
Thanks,
Oliver
