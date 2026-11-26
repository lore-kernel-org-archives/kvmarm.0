Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.221.52
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795723138;
	b=Jo7VfYFXxcA5tNuCMbmffXnptWicVGSQNvDY97S8NC+ZSSDXAqCypOVzF05dJ1trEXQ+
	 +p3A8Ia7Shl3imQXewjkQ3K5FvRg7u7Ad+K/6m3v2OYdLr9iUoLpaIzkUfc9wf14wbgau
	 Assgu2yBX9TifaMUNRp45zLVxEU9vVm9WXVoiDJfUgUl307RSA/LKc7MeZOhnOAtZQaoi
	 VreHpbs0TfbeL2AvFqXuHlRuYFQwuwTMTLkO5h1GTZ+bo1bhpjsOgjvkcnrgzFyFtrph0
	 Eqpn+FHgMdMp8gqc4QKbUIBgrv4n2qyIsLJqvbuTEtsgGNcZfW6BvVlAmtqdMz1ZNWg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795723138;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To;
	bh=yYqZFzMQG84g0Prc7XiHjijfNm+nzCSJFJoOZTXl7Ww=;
	b=xl+yySlg8Xw8EUy4FKLp57YfgSwO/t20L0jVbo4VX6H3TdqgDW2Ae3hqRbBkFPSG7uO2
	 j/Obk8SnCfDk1X8XOqejg8+3Wi3dPXGV8O94D0HdkXFM9uRU/tE1Dx23xAN9buDyZQ6fz
	 jvfeoUHbjxNeRp2Z3g/yGg0VS7J+1HFJBxMpqb/r9ygqTTfH6aaDKoZ4XCSxRnDh88k/c
	 CqIUWuUU/Tn7AuS49/Da1VMMCkwKWtphgU3LOYMKQbkKJ+0cPtOMjNdaOM++9YlXYHKRF
	 Jt1uc8Xy35Ueo0whOds+d33LRebNOHIUFv9F+Nj/uR3s89OV/x1g+GFSXRZ9Ku8R/4Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b="Kyr/kCSd";
	arc=none smtp.remote-ip=209.85.221.52
Received: from mail-wr1-f52.google.com (mail-wr1-f52.google.com [209.85.221.52])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACFD6606A31C
	for <kvmarm@lists.linux.dev>; Thu, 26 Nov 2026 19:58:57 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org ACFD6606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=Kyr/kCSd
Received: by mail-wr1-f52.google.com with SMTP id ffacd0b85a97d-48e20ed3b9dso6526110f8f.2
        for <kvmarm@lists.linux.dev>; Thu, 26 Nov 2026 11:58:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1795723136; x=1796327936; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=yYqZFzMQG84g0Prc7XiHjijfNm+nzCSJFJoOZTXl7Ww=;
        b=Kyr/kCSdMeP/UN9wChgGyp8XSJMO7fo40UyYMqT/5I8pUE07sxu06su+hpbunCDEoD
         DhuotBDuPfpuSDdzoq0jH7y2WJlBYSJ9lL4b7Pj092q4a7lQaJb2Cb9DluGEhD3tAjKm
         3FYHolP7SDZQgAYxC7TYzKiKnpWw3iEW4QmOVdVcwFL0fFsxIFm1S4WqXjOWmVYlGciU
         3SqVNkKMcdWrB0cuzIVUiXUQYrqnlloE5l25RZb+4UKnB5L26Zi3rryk03eJAswLlXuD
         KUikOelZDlqgyFtCedHy0yi+146vG7+E/OMHDMbwT+ZTOSoQqC7/Sj58Jmi6T+iSdDNj
         EMKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795723136; x=1796327936;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=yYqZFzMQG84g0Prc7XiHjijfNm+nzCSJFJoOZTXl7Ww=;
        b=mV1gY2xqgBwHRhqBXBhWrV6xB5UL9fsQRfx3q9bOOFKuqDjj7RNcKpfpXVESvLUEjf
         n1otGtjKgNC05HlAxqWR9u/MVmD83ryrN56K2HaV3ZJaGihzN7y1Q0kOEaarsmQ/bQhd
         bLMbEgS9YPyLwn0SgTmiAehyp1uuELFqE5uEtL1rwApNXGRJjpKyFl6AwYWwsKE5otyM
         RcTLwMrf0U0n0Hl6CYiRsEvNsp/TsESzVk8XjrhId7zhkuIkJsS2qk6HZG8NYCGhPSWg
         +s+tS1KK19RqlATVYQpXfmrYvEXWw9KTKQMTrJ1lZrf5PHQaFv1mjIJJTN8ri2nm6XPW
         Emhg==
X-Forwarded-Encrypted: i=1; AL+hErG7HxyHqi4OAc32rXvPS0gPbNygQfYSIVxiUuU4N2lwKBgWvKuhdEee4dZXvqaFPDGYWz7Cz2I=@lists.linux.dev
X-Gm-Message-State: APuU4Z8IsyHTTvZV+cmKyKLJ3KOKbL83muiL2yef8OcXRIXc9Ic5x+kD
	M8XpS1yHQtgWAyceyx7uFGgTZk3BIVn2YtgAXB+ThJmCP5bW88dMq7Eh0EIlwKwmtw==
X-Gm-Gg: AZFdTZcgOMoqu7t+VcSwGTGI19hwxxOy20+VTlBKiAMEqbBoToUaF54cVTVRm3lmU7s
	iklaV5qWUBPgn9eK/U8BveIgs0/uBe8LKEOPOBp0k3ZvA32kdbm6G0yBpWi+oatdpOFNUVaWa5i
	j+FxXox904OY14YbSW9KU7U9r8hUhGUnzH5mmaEeQEYIJIjNEBclvUgOkVsHblXupcFu8zkBtYK
	gjNp+iSwgJ1GdtrTSuYCoHI/0Yd+NSP4IJ6BVkQ97FjK3BtXlPk7IX69H10U441gBxinwmZvphT
	BKDFQh85uC/AEKJgXwRUFpzrJY34a5kNBlzzHGUSYzWPHridqbQtngJA6nA20oAoBLUThP8bbda
	kiLmTJNwIgMe78h5+wY66tY60Ws7Ja98132qbH14TcqMLHJQIRT8rj3twI1KZoqB3ebJgX3HRSs
	CoVa1e82Cy53+1J8Vt/byU04M6nzXO0/QB2BTawiHI9GM/xQhVaALmmLGIjFO9yOOPX4+I6oEd9
	44pdPKXp3hT6/0WmTpfQ+81ETIQ9s780K4fs5w14EGEbEeW6i+Y7TOuePMC2MX99VpGKqluy8/u
	2j1NcZDcaBO+wECWGOe5QUSKDTMueExCtxS/+dC2pjT0+qXttPa7dC8SJZHdGponXRqG3hCfcBL
	NB3jlyE4aiwq3gQrWX90Hm6NwpKADfkzeoAFxvHP6Dtk=
X-Received: by 2002:a05:600c:4e4c:b0:4b6:5dac:b61e with SMTP id 5b1f17b1804b1-4bb88938d2dmr414850105e9.32.1795723134933;
        Thu, 26 Nov 2026 11:58:54 -0800 (PST)
Received: from google.com (0.182.34.34.bc.googleusercontent.com. [34.34.182.0])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4bb8533579csm543567785e9.2.2026.11.26.11.58.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Nov 2026 11:58:53 -0800 (PST)
Date: Thu, 26 Nov 2026 19:58:50 +0000
From: Vincent Donnefort <vdonnefort@google.com>
To: Fuad Tabba <fuad.tabba@linux.dev>
Cc: maz@kernel.org, oupton@kernel.org, kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org, joey.gouly@arm.com,
	seiden@linux.ibm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com,
	catalin.marinas@arm.com, will@kernel.org, kernel-team@android.com,
	qperret@google.com, weilin.chang@arm.com,
	Keir Fraser <keirf@google.com>
Subject: Re: [PATCH v4 01/23] KVM: arm64: Prefault host stage-2 entries on
 block split
Message-ID: <awiPetTWkhFXj_0M@google.com>
References: <20261117174403.58762-1-vdonnefort@google.com>
 <20261117174403.58762-2-vdonnefort@google.com>
 <CA+EHjTyCo3oUiRUeLQ_YStLAzmD8J8i1kJD4H8qYLyn5EHdp=Q@mail.gmail.com>
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
In-Reply-To: <CA+EHjTyCo3oUiRUeLQ_YStLAzmD8J8i1kJD4H8qYLyn5EHdp=Q@mail.gmail.com>

On Mon, Nov 23, 2026 at 07:24:16PM +0000, Fuad Tabba wrote:
> Hi Vincent,
> 
> On Tue, 17 Nov 2026 17:43:40 +0000, Vincent Donnefort
> <vdonnefort@google.com> wrote:
> [...]
> > diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
> > index 9c83837b184d..dfbcdd3d91a4 100644
> > --- a/arch/arm64/kvm/hyp/pgtable.c
> > +++ b/arch/arm64/kvm/hyp/pgtable.c
> [...]
> > @@ -1053,6 +1095,9 @@ static int stage2_map_walk_leaf(const struct kvm_pgtable_visit_ctx *ctx,
> >          if (!childp)
> >                  return -ENOMEM;
> >
> > +        if (pgt->flags & KVM_PGTABLE_S2_IDMAP)
> > +                stage2_map_prefault_idmap(ctx, childp);
> > +
> >          if (!stage2_try_break_pte(ctx, data->mmu)) {
> >                  mm_ops->put_page(childp);
> >                  return -EAGAIN;
> 
> Should kvm_pgtable_stage2_annotate() end with a dsb(ishst), like
> kvm_pgtable_stage2_map()? With this patch, it installs valid leaves in
> the host stage-2 too.
> 
> Cheers,
> /fuad
> 
> To unsubscribe from this group and stop receiving emails from it, send an email to kernel-team+unsubscribe@android.com.
> 

Ha, excellent catch! I believe it works nonetheless because
__pkvm_host_donate_guest() calls kvm_pgtable_stage2_map() after.

-- 
Vincent
