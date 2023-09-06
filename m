Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11228EC7
	for <kvmarm@lists.linux.dev>; Wed,  6 Sep 2023 08:01:06 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 9201222407;
	Wed,  6 Sep 2023 08:00:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1693987258; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Th6i3Ci6XMV5czHwHHRQpy4WXZpYK1vSc4mKPzvASOU=;
	b=Pb4lNhvGotAuMduqcxpX1veGfBW2fSsxbs9Pu7MCDvZuKYqbhIBY10E+hTUliKOLBUS8xT
	IScFwkZq92rxWtvku6iqGuFuVgR5lDAVbkoOihu7XH0KTBnfaYqyy4A7lldnkADZSSK6sy
	waSNnkdND+zVot6yoT1DyeMpgGyp2zc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1693987258;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Th6i3Ci6XMV5czHwHHRQpy4WXZpYK1vSc4mKPzvASOU=;
	b=8aX8Ngai6ZtyQlD2914oRoaCD9456/pp3O+p6YtiEHc05I1uh8Iu/T2mBUnSMDxI5k/fIo
	p/VLTw2WkzUAHvBQ==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
	(No client certificate requested)
	by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 8ACD11346C;
	Wed,  6 Sep 2023 08:00:57 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
	by imap2.suse-dmz.suse.de with ESMTPSA
	id 2QG0ILkx+GRiVwAAMHmgww
	(envelope-from <vbabka@suse.cz>); Wed, 06 Sep 2023 08:00:57 +0000
Message-ID: <bcefb739-b45c-8349-8010-ac137ab61c29@suse.cz>
Date: Wed, 6 Sep 2023 10:00:56 +0200
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.14.0
Subject: Re: [PATCH gmem FIXUP] mm, compaction: make testing
 mapping_unmovable() safe
To: Sean Christopherson <seanjc@google.com>
Cc: ackerleytng@google.com, akpm@linux-foundation.org, anup@brainfault.org,
 aou@eecs.berkeley.edu, chao.p.peng@linux.intel.com, chenhuacai@kernel.org,
 david@redhat.com, isaku.yamahata@gmail.com, jarkko@kernel.org,
 jmorris@namei.org, kirill.shutemov@linux.intel.com,
 kvm-riscv@lists.infradead.org, kvm@vger.kernel.org, kvmarm@lists.linux.dev,
 liam.merwick@oracle.com, linux-arm-kernel@lists.infradead.org,
 linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-mips@vger.kernel.org, linux-mm@kvack.org,
 linux-riscv@lists.infradead.org, linux-security-module@vger.kernel.org,
 linuxppc-dev@lists.ozlabs.org, mail@maciej.szmigiero.name, maz@kernel.org,
 michael.roth@amd.com, mpe@ellerman.id.au, oliver.upton@linux.dev,
 palmer@dabbelt.com, paul.walmsley@sifive.com, paul@paul-moore.com,
 pbonzini@redhat.com, qperret@google.com, serge@hallyn.com, tabba@google.com,
 vannapurve@google.com, wei.w.wang@intel.com, willy@infradead.org,
 yu.c.zhang@linux.intel.com
References: <20230901082025.20548-2-vbabka@suse.cz>
 <ZPfAL0D95AwXD9tg@google.com>
Content-Language: en-US
From: Vlastimil Babka <vbabka@suse.cz>
In-Reply-To: <ZPfAL0D95AwXD9tg@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 9/6/23 01:56, Sean Christopherson wrote:
> On Fri, Sep 01, 2023, Vlastimil Babka wrote:
>> As Kirill pointed out, mapping can be removed under us due to
>> truncation. Test it under folio lock as already done for the async
>> compaction / dirty folio case. To prevent locking every folio with
>> mapping to do the test, do it only for unevictable folios, as we can
>> expect the unmovable mapping folios are also unevictable - it is the
>> case for guest memfd folios.
> 
> Rather than expect/assume that unmovable mappings are always unevictable, how about
> requiring that?  E.g. either through a VM_WARN_ON in mapping_set_unmovable(), or by
> simply having that helper forcefully set AS_UNEVICTABLE as well.

Yeah I guess we could make the helper do that, with a comment, as gmem is
the only user right now. And if in the future somebody has case where it
makes sense to have unmovable without unevictable, we can discuss what to do
about it then.
