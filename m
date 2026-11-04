Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793815579;
	b=YIn6GXn+25F4uGKEl9QNVOn+FPKJrqwzf3g9yj9xC+tU6+vKGKLf0B/xw3P0O37DlXAx
	 5VKnOKLU2jFV/CdHtAhxaswdGVoaxWtH8aW4FXHh3mTKP+mGspC1YHvlgAceEdRkrpLuO
	 pgMzD+Yh7NsYGJ4ynYnJAa/8SXoiK1/w8Aku9+i4hZYokZCx06hoEkG/C4hOrEnjdfZ9e
	 FJzzePUxi/QpZaQ8aJzKBO1Z/CiBvEPYXglm+YHMoD3pNd+6xFmlbgTqaL6yROiyyf0fj
	 Wty838JPLQ5sb73PJqWYMqV6RUC50tXGkPuPO/kjOe9zz5swQJ3u9cJwkhVnv/5J7Ug==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793815579;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=BKcs+4/yEuxVnS2VouqR2WzhlLvVEKGo4vjTDXvNfG0=;
	b=1vstN06z/PRaCKPDkTmmyeiJDRdYtduKLZkoiCnarFS/z5hHi00ac2rCh+dt8R4dqHM/
	 qQ+yWXVIgICAmKS59hmnl6kMCH+8dPevdF/+N6cQrBj1NhaQkwhreyZsmzYN0Qn2zdb3R
	 hppT/8GBDEsMdVXSU/h/uscBME83XdK5D3F/NkneHrOU7kYohfQhcCluHIARE/LATFOSI
	 2A21nBOS9J4mn7Zg2bH3qK+goTpFi4+BWdFgvZQUfFDlcJJOdjsnbqVeI6Zd+VE3nO6Dz
	 i5rg2jSCiuluZvjYcROPbbrBizAqGDZJ6v3fID9Z7wmLnd0bk/HlVC8wTC+zz6kNOSg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=TRjh1EW7;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 189A2606A328;
	Wed,  4 Nov 2026 18:06:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=TRjh1EW7
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 599191F000C1;
	Wed,  4 Nov 2026 18:06:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793815578;
	bh=BKcs+4/yEuxVnS2VouqR2WzhlLvVEKGo4vjTDXvNfG0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=TRjh1EW7SELcNJfvo8muQIl89zA8WNp5y+E/1UNt7WjdfWpTr2l0YsLmXukzDVdcb
	 MtN2Cul5ftUHPOTHRrWXZz15d4519+/JX99BQ9EFBwDMa6Z/p/gA/7JD6TVOjZ/vBi
	 OB2BFXWBdTOLqM3i58cTC7RkkGMn7JN3bmprsMKqcRE4sWc3gaCR5ux18JUu+f9BiO
	 BCPYty2It/rmH4QXelFrEbogHGZF8Vt5TPltvlSpfWz7CqHpOWk6+r1T5T2x9a+Mth
	 pJ5gQEHLZXIi9vb1beXsTVGfz4uej5iLeuj8/pO+5HwMB3yX/Yju+Mj/kKNoIeWGj2
	 9/KBA+HcaF4xA==
Date: Wed, 4 Nov 2026 18:06:12 +0000
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Sean Christopherson <seanjc@google.com>
Cc: Alexandru Elisei <alexandru.elisei@arm.com>, pbonzini@redhat.com, 
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org, maz@kernel.org, oupton@kernel.org, 
	suzuki.poulose@arm.com, kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	david@kernel.org, mark.rutland@arm.com, ackerleytng@google.com
Subject: Re: [PATCH v2] KVM: Ignore MMU notifiers for guest_memfd-only
 memslots
Message-ID: <autwsR83Ii-tRrqF@gremlin>
References: <20260714160411.302386-1-alexandru.elisei@arm.com>
 <amPCdAswlk24Xilf@google.com>
 <anxAGkdyPYXBlS00@raptor>
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
In-Reply-To: <anxAGkdyPYXBlS00@raptor>

[updated David's email address to @kernel.org]

On Wed, Aug 12, 2026 at 10:42:50AM +0100, Alexandru Elisei wrote:
[ ... ]
> On Fri, Jul 24, 2026 at 12:52:20PM -0700, Sean Christopherson wrote:
> > It'll probably take me a few weeks to circle back to this, as I finally crawled
> > out from underneath a pile of urgent and am just now getting back into review
> > mode, but this is fairly high on my todo list, so with luck we might still squeeze
> > this into 7.3.

Hey Sean,

I wondered whether you'd had a chance to look at this?

After discussing this with Marc and Alex it is clear that this is really a
blocker for Alex's SPE series, as we need a sensible means of ensuring
that stage-2 mappings stay in place.

So ideally would prefer to get something like this in in the next cycle,
if you don't have any objections to it? :)

If it'd be easier, I think a smaller version of the same patch would also
give us what we need? I.e. your snippet from June with the page ageing part
dropped, as below.

Thanks!

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index e7fc94e2910a..a6f37bdb0902 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -264,6 +264,7 @@ union kvm_mmu_notifier_arg {
 enum kvm_gfn_range_filter {
 	KVM_FILTER_SHARED		= BIT(0),
 	KVM_FILTER_PRIVATE		= BIT(1),
+	KVM_FILTER_USERSPACE_MAPPINGS	= BIT(2),
 };

 struct kvm_gfn_range {
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index cf4cb586f140..6fc3b443c305 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -616,8 +616,13 @@ static __always_inline kvm_mn_ret_t kvm_handle_hva_range(struct kvm *kvm,
 			/*
 			 * HVA-based notifications aren't relevant to private
 			 * mappings as they don't have a userspace mapping.
+			 *
+			 * Memslots where guest_memfd is the only memory
+			 * provider can also safely ignore changes to the
+			 * userspace mapping.
 			 */
-			gfn_range.attr_filter = KVM_FILTER_SHARED;
+			gfn_range.attr_filter = KVM_FILTER_SHARED |
+						KVM_FILTER_USERSPACE_MAPPINGS;

 			/*
 			 * {gfn(page) | page intersects with [hva_start, hva_end)} =
@@ -724,6 +729,17 @@ void kvm_mmu_invalidate_range_add(struct kvm *kvm, gfn_t start, gfn_t end)
 bool kvm_mmu_unmap_gfn_range(struct kvm *kvm, struct kvm_gfn_range *range)
 {
 	kvm_mmu_invalidate_range_add(kvm, range->start, range->end);
+
+	/*
+	 * When reacting to changes in userspace mappings, don't unmap memslots
+	 * that are guest_memfd-only, in which case KVM's MMU mappings are
+	 * pulled directly from guest_memfd, i.e. don't depend on the userspace
+	 * mappings.
+	 */
+	if (range->attr_filter & KVM_FILTER_USERSPACE_MAPPINGS &&
+	    kvm_memslot_is_gmem_only(range->slot))
+		return false;
+
 	return kvm_unmap_gfn_range(kvm, range);
 }

--
Cheers, Lorenzo
