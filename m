Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.167.49
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794925935;
	b=yQ4YwbIPxYu5vmOt/SAVeLZBwkvPKQ1MRSPXyjI0jXYfV98sh8lEaXJlXsREJayLBLnS
	 kSF3hbSKyTgkywuAcbmyTU7uDItBXGrFt8lcjAHErrY0BESXuryQQKJu4ynp4JOAilDaF
	 QsOF4kEHg8GijNTQ9kvOMUjR+08hjpxjFbMDx4BTvcX6P2/NqP9YwSz3LeHFJQzkID/2c
	 h7TrpL83t6pMKA+FgXY8x/ieJpziM3oB4GrQpcNzFu+ujlfe8WP5FqaOWb4QpwodfnTpg
	 a08hER8riZz//QlyRC2UxdNGoDKKev4wC5rAxbHArs57b3Z4l5Ni4LwZgWZRuxDU9iA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794925935;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type;
	bh=D3nGp/c9ERuihiWyblYj7YcY7eqF7eIZSBxt1bWzptA=;
	b=PBxhryXAOuhO0kb4/nGnWCqFmx8Yx1eN5vFQ/7fhCeHb4QBpY0DkuZJz8TJ7NdsdmWCJ
	 v9q34Z2c5WYG+WNWaqHGsm+gOR7VdVpKy0ii5VuP1cYPZmkfWMjeGlSOxzqEcVc9sfc5F
	 Er4sWSN3M6ygshDdhMTr3ItbFEBmgvnQFzuF7yXYyrsbieTWq6+StDH/2HjRer3Wu+siV
	 hH14oJby7oGrP1K7kqF/8XgMFZIYkHvOZLKPttx5Xe/2iz1QafnAUXmcYfaRQ9JMsnyjS
	 SMXkUjY85mJRsRxW3d+g9ttQ0l5xiuzop6N+G9jTS/sWIM2ua76hymifWZXcpZACI8A==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b="Fvd9/n65";
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.167.49
Received: from mail-lf1-f49.google.com (mail-lf1-f49.google.com [209.85.167.49])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1C10606A32F
	for <kvmarm@lists.linux.dev>; Tue, 17 Nov 2026 14:32:14 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D1C10606A32F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=Fvd9/n65
Received: by mail-lf1-f49.google.com with SMTP id 2adb3069b0e04-5c00d7ac49dso7451e87.1
        for <kvmarm@lists.linux.dev>; Tue, 17 Nov 2026 06:32:14 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1794925933; cv=none;
        d=google.com; s=arc-20260327;
        b=dNo0LUsZma+W0EAY8xZcEwGGkIJkFMu4V6ktB3FKOmk3M/ZFsLL6xkVGng1aHEE8TT
         tm/b593j6QXIbeZf+havU6/3S3po+Yjr7WeCb5rVZvHeE5wAMKbTDQz5MkuH5GOlbEQv
         VVfa48oIQG+i6h+fDgfK97IIo7HUgScH+injiXfB+ol2kFMrok42b47hAEO+OHjSgl5H
         tHK6FcMIgVq9nF4A3F2bL/BDtOf6sySBpii9GNwNXsjIAHugBJoHGnisidsdq+nIWOKQ
         0mCytGjCkbXTFzzTXlomycQFdgg/lPhN0enYSwe5tQR6iQVnF5wAngDan1wlru9nYcPE
         ciyw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=D3nGp/c9ERuihiWyblYj7YcY7eqF7eIZSBxt1bWzptA=;
        fh=04ozd5cSHd0OMgDPx07KREo7H8nTlxASPCnTELy241Y=;
        b=bXM3b0Yu4LrDMDM8PAoXns9zh87RFLG1h9S73XtdW4o6/TQmhnn+dI9ZU6PrZuN14m
         4dNvextkXjATcFyMl+YjudqsChYgGOtFip0sclkp16CuZ/A9pjgAnrLuZEDKdpPlaQdn
         KO49fuFHflXOq5iMRpNxRW12dYRVDiJ3PSQDMPwFRM9YAua7svy1f/TI7/pRLUDPMX9g
         05/OJgK9vK9cmQyjiA5rMa8niwSCIZIa18G016QjUOe7N9ObdbeRg/WDQgtG7mEqckmr
         o/5tBgjb5WqdoIc/YqDLVOFpLeGAKUU6QlhBKu8PmWJlbmoq6elo1AFl4V4EoszCKIyl
         uqFQ==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1794925933; x=1795530733; darn=lists.linux.dev;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=D3nGp/c9ERuihiWyblYj7YcY7eqF7eIZSBxt1bWzptA=;
        b=Fvd9/n65nwL3uC1H7+vXOndTzQdxCVguJQWvZDPPjm4IeebQpsf5Ff5+Nwwz6fewBq
         VVWh8BALPhTLlRz5JCDk5cCsWXPotPCUoL38C7FraX359ZFzg8hCeFgdvC+l8uw9dkaA
         xRsoaJj138lUhoY1vBXGtyv4kkzDJloBtkTej0jlNQCFs46dOZbrg3BsOyhjMWHIp7nt
         XDPo4hX7og01omaeUWD2Zqku7uF+qVU7N4ial29rEKDP7mXWeQg5+vVXKJq5GNrDoLKv
         K0f74TT2BZRXH/2/08OO52bdIERVlflLSphWpeoFwEFByJAcOGa/C8JSCvSFkUrnxu8C
         dt0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794925933; x=1795530733;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=D3nGp/c9ERuihiWyblYj7YcY7eqF7eIZSBxt1bWzptA=;
        b=hfGLT/z+Grfg0bne5w/oZGWdR2CP1v4iZmG5zHYJoOy5ZsPqqC+TuX4ZC8OsRcdjHg
         +95WUFad6P5gic2RxAXaQ+5fMtewQmYOhl/g0BzgP9ekmtdMeRVui7bED5j5QACMX33k
         q2L/Iq2FvzTtvyjrVBX8HG2ehypMlmWAkhvCQOH4n2P5xbIH1vDDW+dj6Ds5j12m+/it
         WyQBCY7Llzs4RoYmhtZSKQfx7HEWOSqIPhTx3uVSUtVUIIXQQ3alSE2UY47wh7QaCynI
         HTte4aZ/ahwOHjOErG1XtHN+ycCW8ARWgJNLUok+eB1GEN1dtvgb1JXRGc3vTz7DzR6Y
         l72w==
X-Forwarded-Encrypted: i=1; AL+hErFfeKq+kF/ZcnMs3fdlAoQpOv8B0eOQb/hO7fc3XOHu3OZ6Qx6l06pj1uZFDOIJypV4yEe50Uw=@lists.linux.dev
X-Gm-Message-State: APuU4Z8jKkZG7Zj/KOepWZynl5r6ug3AfkUu1EdIX6bOQurrd1TyEqap
	6eVLzWTx6Vzswe5HAu6i8tKWLQGjiYpErjz6grk3lB4VgOL6dBbYT8pIh7UM/7tinrDoqN+Ve3o
	D0CxwMoCOhIyjSNMLW7HQ6KlrZb8KqAkCr+lksEei
X-Gm-Gg: AYBFou11K8NmqTfV/GrT0MVQNtFBGu7/wQjRSAf2G075LwJ0T/hKgKm+dkwt3KlNoCg
	9NHxCjWBoCOjrtgHgD4O5Dn252wGkzVLpVM+M+n5vevgG0dK1vwMZxBoJQkniNf06h9fAeJF73d
	lsgRwRlSfriZT6hHWGfbQN65sqCnyyzvfWmXxJVGSPJOShVkJfCiNCsEwxxfAR2EsF3l0fjGVLj
	EEYDym3RlPyvjon6pqC6K8rtAOxenaD2O1neWHqy4JnP2j1j8Hl+IIG59/On56x+pO18gn+4CZA
	V8heNW4DbsSMtcwJsoADkDZR+RnB4oOmaLU6GXozElFD9lkF/25jMzlxjQcxW68knYHHRL5so9E
	kxitN4/zeHGM8NBnX2HaN9ly5jILB8nmZsOSZc5E6oo3r5ldiNlSAg6hKOuRoguEKlcGBjkDvC9
	PRV3nde8Ag9Mt8/VYO97TEoJQ=
X-Received: by 2002:a05:6512:1111:b0:5c1:4f9f:1ae6 with SMTP id
 2adb3069b0e04-5c1a217f086mr135560e87.15.1794925932245; Tue, 17 Nov 2026
 06:32:12 -0800 (PST)
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
References: <20261116164358.142785-1-steven.price@arm.com> <20261116164358.142785-8-steven.price@arm.com>
In-Reply-To: <20261116164358.142785-8-steven.price@arm.com>
From: Fuad Tabba <tabba@google.com>
Date: Tue, 17 Nov 2026 14:31:35 +0000
X-Gm-Features: AclHuK8jwarv0Qdp1aWUBJu9cvVLVN2wG1yO28RoPz1SpZjEhJ3_zh_LKO1lzYo
Message-ID: <CA+EHjTwqYUBvhjF8dxqVA1mF_Qe1r2UZdwkZ+Zirgmm2um=skg@mail.gmail.com>
Subject: Re: [PATCH v3 07/11] KVM: Allow architectures to reject memslot
 changes before invalidation
To: Steven Price <steven.price@arm.com>
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, 
	Marc Zyngier <maz@kernel.org>, Will Deacon <will@kernel.org>, James Morse <james.morse@arm.com>, 
	Oliver Upton <oliver.upton@linux.dev>, Zenghui Yu <yuzenghui@huawei.com>, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
	Joey Gouly <joey.gouly@arm.com>, Alexandru Elisei <alexandru.elisei@arm.com>, 
	Christoffer Dall <christoffer.dall@arm.com>, linux-coco@lists.linux.dev, 
	Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>, Gavin Shan <gshan@redhat.com>, 
	Shanker Donthineni <sdonthineni@nvidia.com>, Alper Gun <alpergun@google.com>, 
	"Aneesh Kumar K . V" <aneesh.kumar@kernel.org>, Emi Kisanuki <fj0570is@fujitsu.com>, 
	Vishal Annapurve <vannapurve@google.com>, WeiLin.Chang@arm.com, 
	Lorenzo Pieralisi <lpieralisi@kernel.org>, Kohei Enju <enju.kohei@fujitsu.com>
Content-Type: text/plain; charset="UTF-8"

Hi Suzuki,

On Mon, 16 Nov 2026 16:43:53 +0000, Steven Price <steven.price@arm.com> wrote:
[...]
> Architectures may need to reject deletion of a memory slot without
> changing the guest's memory mappings. Currently, KVM invalidates the slot
> and calls kvm_arch_flush_shadow_memslot() before
> kvm_arch_prepare_memory_region() can reject the request. On arm64, this
> unmaps the slot from stage-2. Restoring the old memslot on failure does not
> restore those mappings, so even a rejected deletion has side effects.
[...]
> Move arm64's protected VM checks into the new hook so that unsupported
> deletions and moves are rejected before stage-2 unmapping. Keep resource
> preparation after invalidation, since invalidation drops slots_arch_lock
> and allows concurrent updates to architecture-specific memslot metadata.

For pVMs the invalidation doesn't touch stage-2
(protected_pkvm_vm_s2_ops uses no_stage2_unmap_range()), so the reason
for the hook is the Realm case in the next patch. Can you change the
message to say that?

Cheers,
/fuad
