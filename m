Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.54
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792595669;
	b=Y4aEXsvoXWwawjf4PnlKbZvJnw6rYTLF0m+uh7g0vw4OFVPnJebUvbDUtTsZz0Z3CoZ4
	 BpFjh5pnLHvRktUQICavY0pzc8JftBRutwKa+j8sWBmsisieEtDYJSNe28PzoYFiTVflk
	 YF2tijKeMesl4DPQRo5Ba3+i7GwsKklovl4IbpXuOhDc6v3OIEqiIf5o/j+FOOCHRKBSc
	 sVuT4oZ3ewI/KPLdDWPcsoGPixY+hcsbj6rUiQGYvxCzLbKAOdUqRfFaHp3eUQE44hWqh
	 vIFIeidBA/luBdj9RAqdUMpaQtoJUjI5SOGIQiNh9vUWvTJyso6TSgQXKxYCxZlOXOw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792595669;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To;
	bh=0YZLYsLs1zDQz5M0rn0ZPlb3pIBZFLCQPnvXndpW+/w=;
	b=iZaN8ZYdF2pxRZVq6NExNIKV7xHYMoPYM2ZgtcqXE5RfAkdBFmIHy0+4O1sBzOkFuNFh
	 dwv8sMr+/Na1V4CRnQr67af1g1csVXqjgX9y7He1kP00mFQ4WfOSQWBmRQ9w45IwBEaWA
	 Hlx9JfzFseLUKI9Q1LSJ99zxsJFNAJyek+nf2vMXox81SCjKaTJBscoxvbjDN7l2M4eHR
	 18j2n5R+OupwfHVFjNZUziPUhB9q0wN6pdwdaISbzuEJLxUSDW5kxhzbQZ8ktJhOXaPxy
	 S4J1PD2B/HF5XWxFLy0S7mD3PIZCUqBY/ECtjOuA+oVMs8QmfQrTb1edOUiSnjLiIMw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20251104 header.b=vECqg5US;
	arc=none smtp.remote-ip=209.85.128.54
Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD541606A31B
	for <kvmarm@lists.linux.dev>; Wed, 21 Oct 2026 15:14:28 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org CD541606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20251104 header.b=vECqg5US
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-49d0da752ffso7175415e9.3
        for <kvmarm@lists.linux.dev>; Wed, 21 Oct 2026 08:14:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1792595667; x=1793200467; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=0YZLYsLs1zDQz5M0rn0ZPlb3pIBZFLCQPnvXndpW+/w=;
        b=vECqg5USaV8bXCHzw4Q8Y2uVMYMZxJJcLb/FhTy4S4CU3XaNQwjflxauNSa3mjA2VZ
         BOd+3adBMO6vG5MWeyFjsgsmJneLPOfMk+DXq/sCZI1RVtB0uvV/OM/jxYKqnStreod0
         c5HKQ3PZxz8JK7EHDX7+ZTUIKFPBFJ08paX8wBGLaAfK5BxIutD+wirHbpaBZ4O9i5TD
         6jHdCA5dNXsZWkD1bnA84GxhjvlY0VkaxDuAZxEzvmtKuM1C/B5KwLxcHWaJC3/icE8P
         J2MKaIsQvdaoat5vLRaHbVsoDHXM0N68krpRxswB/cL+kkHQWEA7QpfhdQRrCwNl8xkX
         Uwjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792595667; x=1793200467;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=0YZLYsLs1zDQz5M0rn0ZPlb3pIBZFLCQPnvXndpW+/w=;
        b=yWjqwpsHcOe3YW9E8RfjsO19+cOUrJvQhxcO8PEWXuu8wjmstBVQjXhmwPH1nF0XK/
         FNsY7q4YUrpVXOt5eEapJG5AXg3Fay91V/kVEGhM6Gc96Tg1FHQ0GHEdf59/kTrUm0z6
         4ifjV39B8oxVp+o6TmdpyCa0eO1hvdxFpBd0a2JqgdB0rFnJ6swMyWnaLbJYnNNcNgVt
         JVjvRyyPzwc2ESPC2AkW9VgQGY3gcThbO+PvAL8/3eAg44HhsG5x1jTRZ4nnqLZjqnex
         viLuDrkE92ZBfht9q/4u1vtHDm/7TUxRj25h9kabOKi/LVvR90ZeBFE18lU5vYQ6eU60
         RCCQ==
X-Forwarded-Encrypted: i=1; AKwUvBy7cFn7JoGkD9Az6wT/HlEydBo4LC+wB1Ytn1aQuRzUgCwe2iQUmQ32Wo0tul+zPmnHgZNOzZ8=@lists.linux.dev
X-Gm-Message-State: AFq9FYJiQ4/o5zWXFkzoUMYui/Cy8hZzAevhAXfsfENhZ4m3I5bELwE/
	mtlhlzZkBGohi9ympiekAjKSZ2N1DY6CL9ieuCeMmjnAyGOXyObGGxq6mAzz5zUxUdANFDMu4jA
	hy81wNA==
X-Gm-Gg: AYBFou18DzCWwhFoNNxe1zmewxtlgnQy3uclDbS2PK2PpcpM3Ae2h3OjmhPfE8zDV8Y
	XPSF0rW0inw5w0VhBUwkgAqbD5t7UTb+LJuhemScNkInt4S/y8MzZ9sWTDSrkAaXWz1T0AE9PRG
	yUYMsBqTE/VastHxygyPQirz8SYVG6eAVyp1020bj4qUJ91AID8rc2Ws4tpRGvT4l2KlK6lbjLG
	NELrDiq2TlZHbg5I8ODkqSgxxeA6sgXUZUfzleTua6Xy/ES+na7gkpRBao6OZJlFXFixd7CPCuI
	CXno9m3pzft/Figf5Id2AwfjjQ5Km3IMXnRpTHXY1N0q9FPgfZPzR6GuUEYUwuvlbk6f2zeKSO0
	MUB03Xtxl9xda080sPV/fobX/KDreT9jNLC3sF1Oc513uLiqd4O6Fc/Sr3H9jwVxi0zSz5GdTJF
	2bqzA5qe/8+33r5u+X8tpUZvhJeRd5dg9+j9PJQeJ6aaUjs0lgoTNPI6CkRrAY3EziMVkhg9jkz
	uNroqqZGq1jdMqG2vnbDalX2imLw464VXYHOHtI+WQ6yy+Rz/hQ/l9o/59XNi1FZTVCjh0shNVL
	+/klnbtCjCWNizwIsPPHNlVj
X-Received: by 2002:a05:600c:3e83:b0:4a1:6425:be69 with SMTP id 5b1f17b1804b1-4a1fdb078camr50365605e9.17.1792595666559;
        Wed, 21 Oct 2026 08:14:26 -0700 (PDT)
Received: from google.com (197.183.140.34.bc.googleusercontent.com. [34.140.183.197])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4a1fc1066cfsm58540435e9.1.2026.10.21.08.14.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Oct 2026 08:14:25 -0700 (PDT)
Date: Wed, 21 Oct 2026 16:14:21 +0100
From: Vincent Donnefort <vdonnefort@google.com>
To: Marc Zyngier <maz@kernel.org>
Cc: oupton@kernel.org, kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org, joey.gouly@arm.com,
	seiden@linux.ibm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com,
	catalin.marinas@arm.com, will@kernel.org, kernel-team@android.com,
	fuad.tabba@linux.dev, stable@vger.kernel.org
Subject: Re: [PATCH v1] KVM: arm64: pkvm: Clear GICv3 LRs in the hypervisor
Message-ID: <atjWzRABsApbZ8CC@google.com>
References: <20261021110000.508827-1-vdonnefort@google.com>
 <86qzhjz1iz.wl-maz@kernel.org>
 <ati1DrtmMd-63bIN@google.com>
 <86pkx3yylb.wl-maz@kernel.org>
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
In-Reply-To: <86pkx3yylb.wl-maz@kernel.org>

On Wed, Oct 21, 2026 at 02:25:52PM +0100, Marc Zyngier wrote:
> On Wed, 21 Oct 2026 13:50:22 +0100,
> Vincent Donnefort <vdonnefort@google.com> wrote:
> > 
> > On Wed, Oct 21, 2026 at 01:22:28PM +0100, Marc Zyngier wrote:
> > > On Wed, 21 Oct 2026 12:00:00 +0100,
> > > Vincent Donnefort <vdonnefort@google.com> wrote:
> > > > 
> > > > The LR registers are architecturally UNKNOWN when the CPU boots or
> > > > resumes. However, in protected mode, only the used ones are reset.
> > > > During boot the HVC __vgic_v3_init_lrs() is never called because
> > > > vgic_present is only set in init_subsystems(), after cpu_hyp_init() was
> > > > called.
> > > 
> > > Why don't you fix this rather than making the init even more
> > > different?
> > 
> > Ack, I'll make a patch to fix that first.
> > 
> > > 
> > > > Also, the PM notifier isn't registered for pKVM and the HVC
> > > > becomes unavailable after the host is deprivileged.
> > > 
> > > Sanitising the LRs on PSCI_ON is probably the right thing to do, but I
> > > don't understand why resetting the LRs is out of reach from the host,
> > > given that the host is fully in charge of the interrupt injection, and
> > > therefore controls the LRs.
> > 
> > I suppose I could reinstantiate the pm callbacks for pkvm to at least reset the
> > LRs?
> 
> I think there are two different things:
> 
> - pKVM must not rely on the host resetting the LRs once it is
>   deprivileged (that's the PSCI_ON case)

Definitely not a hot path, but if we keep this one ^, isn't a shame of making
the host issue HVCs on CPU resume to reset the LRs if we know the hypervisor did
it anyway?

-- 
Vincent

> 
> - pKVM must not prevent the host from resetting the LRs (that's the
>   "mind your own business" case).
> 
> Both need addressing. If that means the LRs get reset twice because
> pKVM inherits the PM callbacks, so be it.
> 
> Thanks,
> 
> 	M.
> 
> -- 
> Without deviation from the norm, progress is not possible.
