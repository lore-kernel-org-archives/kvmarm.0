Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.140.110.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795537228;
	b=UMM7vdatYrPGiSwkj3BSbPsv+h98NXJH1f8ZjoRafS1QyXAVCrT56J3ORFYde+iOVL8+
	 PRQUQqaRFB6RMNbXb0hG2ZTHqqss4eFxCQ8wUyAK162LJhoS4GLS5nORcVgiRdHHVQTwS
	 CpawczKzivclhhjpjf5PLNVYwqTrOSP4r4e0gisWtKmSDKsmJfbz9hmVIRIquh9oDyjrn
	 ug6cJFRf8X6kNb4rqYyeSDZmLf8uzCVl7aG1A2QRolNxKjxYdh10RgX8Lv35iVKJ72TQ1
	 8xTpvtANov3aViqYAw1l7eEy3kLzkS9SwpB3Wza8U9ziJZgNM7Oyc6+sBloUYLK9nZg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795537228;
	h=DMARC-Filter:Received:Received:DKIM-Signature:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Type:Content-Disposition:Content-Transfer-Encoding;
	bh=vh0BAdo2m4YNdv43vLdl/BjP3ewFE0kTwJwjZn4sTvQ=;
	b=xj/VP5UJrltrt86wUX6qceZhCY8RkRwn7BtFjJqAHil5XYu54Wm9xN+P9KQym6bn8znm
	 aD0gFwUFS6RMk1LZxcKgoHAwmRUicUzyJHs4VvjQJtYCvGmBt9OYcUO5gVZMEdw8jrQZC
	 mLDBDnitQgKRx3vwLGGQzg//AqEvN/8YIU4jmYgL1hdYM++5dgTbikXFZufCcfUVgNP53
	 wzoyMkg+aMrd5u3KMl1S6SKMwH/0ceDzdSe3/RG+slEgaam/qtCy8KXHL61UiNZx+NSGC
	 KfnVL9OwzzPYW/Q+Tcb+0JOOqgO3FyNcPC8WeTPRW4mJ5xFjSj7WM3VPE5HpbC0R22g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=arm.com;
	spf=pass smtp.mailfrom=arm.com;
	dkim=pass header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=LTrMdE1L;
	arc=none smtp.remote-ip=217.140.110.172
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5652B606A321
	for <kvmarm@lists.linux.dev>; Tue, 24 Nov 2026 16:20:28 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 5652B606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=LTrMdE1L
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 9A4EB497;
	Tue, 24 Nov 2026 08:20:24 -0800 (PST)
Received: from LeoBrasDK.cambridge.arm.com (LeoBrasDK.cambridge.arm.com [10.2.212.21])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 80D4F3F86C;
	Tue, 24 Nov 2026 08:20:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1795537227; bh=mOUbQ4p97y6xrtmHyboo3pUZSt7uQyACpafQkgBuGJE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LTrMdE1LuQCeoCPryQYYWwwsfV4wPqp2aaCA7ba3L+gGy3IvFi+v/W1gpWNnFTmzm
	 UPoSXiPVOhIy5qHty1w5p8yUBxGbBhRkalKi3ydK933L1rVp0uKRioH1xQVljuWo0X
	 P2dg7TH+XlkSbrmvb4PayQNFySKNVu8bzaSnDSDc=
From: Leonardo Bras <leo.bras@arm.com>
To: Marc Zyngier <maz@kernel.org>
Cc: Leonardo Bras <leo.bras@arm.com>,
	kvmarm@lists.linux.dev,
	kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	Steffen Eiden <seiden@linux.ibm.com>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oupton@kernel.org>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Fuad Tabba <fuad.tabba@linux.dev>,
	Dan Carpenter <dan@pereq.eu>,
	stable@vger.kernel.org
Subject: Re: [PATCH] KVM: arm64: nv: Upgrade sub-page TTL hint to maximum size
Date: Tue, 24 Nov 2026 16:20:16 +0000
Message-ID: <awW5QKqGZAqw1ru9@LeoBrasDK>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261123182312.4842-1-maz@kernel.org>
References: <20261123182312.4842-1-maz@kernel.org>
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

On Mon, Nov 23, 2026 at 06:23:12PM +0000, Marc Zyngier wrote:
> Should a guest be slightly foolish and submit a S2 TLBI with a TTL hint
> that describe a base granule size smaller than the host's page size,
> we take the resulting size at face value and feed it to the S2 unmapping
> code. Which legitimately screams about something not being page-aligned.
> 
> The architecture allows us to drop the TLBI on the floor, as we don't
> support a S2 granule size smaller than the host's page size. But it turns
> out that doing so is proving pretty hard (we call compute_tlb_inval_range
> from a number of places, none of which is amenable to an early out).
> 
> Instead, detect the annoying case, and pretend that we don't have a TTL
> hint at all, leaving the size upgrade mechanism to take place and use
> the largest possible size for the guest's S2 granule size.
> 
> This will still allow nonsensical stuff to get through, such as a 4kB
> level 2 (aka 2MB) from a guest with a 64kB S2 base granule size running
> on a 16kB page size host, but that's not worse than doing nothing, and
> the host code won't get shouty.
> 
> Reported-by: Dan Carpenter <dan@pereq.eu>
> Link: https://lore.kernel.org/r/20261123-inval_range-v1-1-815e15797089@pereq.eu
> Fixes: d1de1576dc21 ("KVM: arm64: nv: Handle FEAT_TTL hinted TLB operations")
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> Cc: stable@vger.kernel.org
> ---
> 
> Notes:
>     Reposting this as a first class patch, as I'd like to plug that one
>     as early as possible (and Dan has plenty of other patches in flight...)
> 
>  arch/arm64/kvm/nested.c | 7 +++++++
>  1 file changed, 7 insertions(+)
> 
> diff --git a/arch/arm64/kvm/nested.c b/arch/arm64/kvm/nested.c
> index 78d5b18dbd2d6..36e4e83badf0a 100644
> --- a/arch/arm64/kvm/nested.c
> +++ b/arch/arm64/kvm/nested.c
> @@ -714,6 +714,13 @@ unsigned long compute_tlb_inval_range(struct kvm_s2_mmu *mmu, u64 val)
>  	 */
>  	max_size = __ttl_to_size(ttl);
>  
> +	/*
> +	 * IMPDEF behaviour: treat subpage TTL-annotated TLBI as the largest
> +	 * possible invalidation. Don't try this at home, kids!
> +	 */
> +	if (max_size < PAGE_SIZE)
> +		max_size = 0;
> +
>  	if (!max_size) {
>  		/* Compute the maximum extent of the invalidation */
>  		switch (vtcr_to_tg0_pgsize(kvm, mmu->tlb_vtcr)) {
> -- 
> 2.47.3
> 

Hey Marc,

I think the changes make sense, although rounding up to PAGE_SIZE also 
looks a valid solution in my unexperienced viewpoint. 

I am curious if there is any particular reason not to merge that with the 
test below, such as:

diff --git a/arch/arm64/kvm/nested.c b/arch/arm64/kvm/nested.c
index 78d5b18dbd2d6..36e4e83badf0a 100644
--- a/arch/arm64/kvm/nested.c
+++ b/arch/arm64/kvm/nested.c
@@ -714,6 +714,13 @@ unsigned long compute_tlb_inval_range(struct kvm_s2_mmu *mmu, u64 val)
 	 */
 	max_size = __ttl_to_size(ttl);
 
+	/*
+	 * IMPDEF behaviour: treat subpage TTL-annotated TLBI as the largest
+	 * possible invalidation. Don't try this at home, kids!
+	 */
+	if (max_size < PAGE_SIZE) {
- 	if (!max_size) {
 		/* Compute the maximum extent of the invalidation */
 		switch (vtcr_to_tg0_pgsize(kvm, mmu->tlb_vtcr)) {
--

Given max_size is unsigned (>=0), and it will be changed again in the 
switch case below, I was not able to understand the need to make it zero 
first.

Thanks!
Leo 
