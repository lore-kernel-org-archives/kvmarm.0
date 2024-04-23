Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 976483C30
	for <kvmarm@lists.linux.dev>; Tue, 23 Apr 2024 00:16:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713831363; cv=none; b=P74GIY81ZHpDoZJHfcVf2ThEd+K5EljLZgfjKgUl2oUFZOseqV+cO8hBGap17mJ4X5lCijoXXu2gg/HpnNrlXXfthtpeC8zNdTw9scbVbK2s72oo7N9ETNWni7cfbPfK5h6+E/NYP7vpwOyrJ8eYe2F62ZUnb0mC8bBPUgPSfG8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713831363; c=relaxed/simple;
	bh=6R2GXPZ8MNR9mzZ3mCyCouRoIEDw0zcCo16JjOYAUNU=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=rnImh6Qio/b3A82M2duNj6HQKFjkQSsxgXbL3VQH4RHl3VQXO9kGfcwr8ENdAmI7spDknpqDl7vK2Nmgt1rWSH0OBJ8KCT1lr4dWZkHE/3VQjYtzoMQUfcAwS0bW2avC6soU4p0sbPdIQJF7cxsY55tkL5P1Bpiobqp+gs+pCbM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=iuU65sBW; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="iuU65sBW"
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-2a4f59746f7so5591960a91.1
        for <kvmarm@lists.linux.dev>; Mon, 22 Apr 2024 17:16:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1713831360; x=1714436160; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=8H1kEVLpGrJ5ZWFkENA9219fhA8vfTYgGM3sZ6TDcgI=;
        b=iuU65sBWA0RZbazbm0I42vfhnqrLrYTXrPoFRV7RGGNwb+1zHM1Dhpshr5QqgLVr1o
         2FaHE2KZDHl9RGsfdGWA2SqgEYp61gNtVwdbbdhOGpI9YIDJwkVqkTqAwM5x4DPnVMB0
         YedkbZkbojfSYWkmAQIrMl+fBYnP3xnq5kL/0M9402CkLrAqcpS8ONomnQYMUjHynv9K
         pEg2EkD0Arhguu+v6XNwNu3oy2fgSeTvWpcMlpQ8+ELIxkLjmorpAIXVfR2TCJbJ6CPj
         h5lTPUzdpZasZLppYD0GdbBKxTi2MAkjOdsJY6vXbB+28qucwOFP2DWQ1Syf37lxxfk+
         /d8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713831360; x=1714436160;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=8H1kEVLpGrJ5ZWFkENA9219fhA8vfTYgGM3sZ6TDcgI=;
        b=tqo9WbLi3JHBZGt2I2VPTXhcn8AotYi7GCEsDIO5hmsnMttIql2BEyFRq+7xuzJysj
         h8VGSBpR6ijczrqjNOF3gGhffcewNxmIg+vkJftOhBcZ094izqZnrp7e1lHqhGDgt4nh
         kvqlFLFm53q9CFRUuaAjcS+4Cxp+ONTYaUMdshxk/3iuDE4mmFI2QRgTu5vsXVLNrFLq
         Rm2VlnKEt7pi85RT4wN0IWRL3jL0deudNzcXZbXlOgG95B/pHjGhlPINxE6d/QCzVd/F
         8cRQXcDSgwX5lz+6JrzDd+sBE0A31mkHZ0TMRTs8w6HlqihcJ+CsNWSfG2q6lcI/bTny
         9W1Q==
X-Gm-Message-State: AOJu0YxjJwudHDVMCs+ep5QjUiXzjujbihLjTFj9XoRDTKfpb+AeNFW9
	9AWZD3V91Wc2xEQRARM02J29olTs9jmd7OCgyyX18/QY1Hf/Lo1kbXfsA9bRm6m6Fk+o6rAXToQ
	EtA==
X-Google-Smtp-Source: AGHT+IG/qs/+QwIoau+irouJ8WnFn/4gnZ82DbdmH2gIfH86uzFQlhjZer6qP3BdeeJABXE5gW74XoOxbZI=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:90b:3145:b0:2ae:6e94:b02b with SMTP id
 ip5-20020a17090b314500b002ae6e94b02bmr5770pjb.4.1713831359878; Mon, 22 Apr
 2024 17:15:59 -0700 (PDT)
Date: Mon, 22 Apr 2024 17:15:58 -0700
In-Reply-To: <20240422200158.2606761-2-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20240422200158.2606761-1-oliver.upton@linux.dev> <20240422200158.2606761-2-oliver.upton@linux.dev>
Message-ID: <Zib9vslQW1iLrBAn@google.com>
Subject: Re: [PATCH v3 01/19] KVM: Treat the device list as an rculist
From: Sean Christopherson <seanjc@google.com>
To: Oliver Upton <oliver.upton@linux.dev>
Cc: kvmarm@lists.linux.dev, Marc Zyngier <maz@kernel.org>, 
	James Morse <james.morse@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Eric Auger <eric.auger@redhat.com>, kvm@vger.kernel.org, 
	Paolo Bonzini <pbonzini@redhat.com>
Content-Type: text/plain; charset="us-ascii"

On Mon, Apr 22, 2024, Oliver Upton wrote:
> A subsequent change to KVM/arm64 will necessitate walking the device
> list outside of the kvm->lock. Prepare by converting to an rculist. This
> has zero effect on the VM destruction path, as it is expected every
> reader is backed by a reference on the kvm struct.
> 
> On the other hand, ensure a given device is completely destroyed before
> dropping the kvm->lock in the release() path, as certain devices expect
> to be a singleton (e.g. the vfio-kvm device).
> 
> Cc: Paolo Bonzini <pbonzini@redhat.com>
> Cc: Sean Christopherson <seanjc@google.com>
> Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
> ---

Reviewed-by: Sean Christopherson <seanjc@google.com>
