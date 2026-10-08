Received: from mta1.migadu.com (out-32.mta1.migadu.com [95.215.58.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2AD03A2551
	for <kvmarm@lists.linux.dev>; Thu,  8 Oct 2026 19:14:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791486850; cv=none; b=FkwsZ5EMawmvFH82GFCdLHC/QDxAUdBAbS2SFLgRe0r8AZxpNEh5ugjkUwwdonBXIQYRi6v5aFBxWXZ8uwbsjMbq8n7UPSRkmG9nNp3DwmFz6EvV5alHShmhoHiA2N9Fqae52eAWJQZ0bPfHHcb1lnfCbkIz1KQ+idbgS/t0kQQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791486850; c=relaxed/simple;
	bh=AKR83nbVxbLcyLekP2tauXtp08m1xfpMBejB0OmP9ZE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=K4wl6ljO+lD1L8CrYJmy9uVnHdcVPBbEeHgxkWXvZEEJDwfSL/MGDy7dOBk5n6HdRhXfYGfHjP3rYBi6pCFfOnZ4tbzqtRS76FlYc4cNVf/BAWW1o537LXph6KRRkx67lOTEt+PdS6bsAUuw+QQqraisXa2NTh2hMInTs/wMhkc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=GRuT9Pyj; arc=none smtp.client-ip=95.215.58.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="GRuT9Pyj"
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=AKR83nbVxbLcyLekP2tauXtp08m1xfpMBejB0OmP9ZE=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1791486846; v=1; x=1792091646;
 b=GRuT9PyjtrKV24zT1m7nKq1byVdCATSTjL+r8gnAdQwNlBYb78zys/K7PHd5x32e/sdefucx
 A/dHh/DV8ctGiZ9kImFkQA/6OFLjcuL7jbpGNDi4D+1no3udWAYAULtg3I311ASVoBFWJlMvksH
 xqvgvaNcZOw6VqMT3HBgUO+A=
X-Envelope-To: kvmarm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id 76e91f6e026d46b3;
	Thu, 08 Oct 2026 19:14:06 +0000
X-Mizu-Trace-ID: 76e91f6e026d46b3
X-Migadu-Flow: FLOW_OUT
Received: by mail-lf1-f50.google.com with SMTP id 2adb3069b0e04-5ba40832934so223e87.1
        for <kvmarm@lists.linux.dev>; Thu, 08 Oct 2026 12:14:06 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBwX34fgf6sVA9950A5OtDcwC60fP9e3b2EvjlNXvGIl0CCfzpYT5tkutZ5+DJqQN7EdEs4ky/k=@lists.linux.dev
X-Gm-Message-State: AFq9FYLC88FI4ZctuG7881pZw5u3mLQ0iQNot+X0nJjGnhv1tKVg2WLl
	N9lNo0d0hzydz5yOAiUdnBmI0+q3YNWeAWou66l3knpHyoyfO/KKee8E89qxztJKg4UpixJIWmi
	oFVTNe7rtogqp+OCx7AQiHmZmAxjTQfAUj9o+hxHW
X-Received: by 2002:a05:6512:10c1:b0:5b8:c230:1241 with SMTP id
 2adb3069b0e04-5bcdd4f70eemr5332e87.10.1791486845553; Thu, 08 Oct 2026
 12:14:05 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20261008104212.3134550-1-vdonnefort@google.com> <20261008104212.3134550-3-vdonnefort@google.com>
In-Reply-To: <20261008104212.3134550-3-vdonnefort@google.com>
From: Fuad Tabba <fuad.tabba@linux.dev>
Date: Thu, 8 Oct 2026 20:13:29 +0100
X-Gmail-Original-Message-ID: <CA+EHjTzpKk3hUTriyRF-YWkNQpQ82vuJoqKkW+uo+6n5f2mhmg@mail.gmail.com>
X-Gm-Features: AclHuK_ThQjFI6b4HwbVAIZDiFDSYYuCsea3IqDte6EDuPAwAowo5mbSypT5SSs
Message-ID: <CA+EHjTzpKk3hUTriyRF-YWkNQpQ82vuJoqKkW+uo+6n5f2mhmg@mail.gmail.com>
Subject: Re: [PATCH v1 2/2] KVM: arm64: Fix bpages backing allocation size in hyp_trace
To: Vincent Donnefort <vdonnefort@google.com>
Cc: maz@kernel.org, oupton@kernel.org, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org, joey.gouly@arm.com, 
	seiden@linux.ibm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, 
	catalin.marinas@arm.com, will@kernel.org, kernel-team@android.com, 
	qperret@google.com
Content-Type: text/plain; charset="UTF-8"

On Thu, 8 Oct 2026 at 11:42, Vincent Donnefort <vdonnefort@google.com> wrote:
>
> hyp_trace_buffer_alloc_bpages_backing() computes nr_bpages as
> (PAGE_ALIGN(size) / PAGE_SIZE) + 1, whereas trace_remote_alloc_buffer()
> takes into account the buffer page header.
>
> Align the bpages backing allocation by using
> __calc_nr_pages_ring_buffer_desc(). There's no need to validate
> nr_bpages again, it has been before with trace_buffer_desc_size().
>
> Fixes: 3aed038aac8d ("KVM: arm64: Add trace remote for the nVHE/pKVM hyp")

Should this have Cc: stable too, like patch 1? The undercount is there
since 3aed038aac8d for small buffers, and 442ffa742daa6
("tracing/remotes: Account for ring buffer page header in size
calculation") makes it reachable at ordinary sizes.

Reviewed-by: Fuad Tabba <fuad.tabba@linux.dev>
Tested-by: Fuad Tabba <fuad.tabba@linux.dev>

Cheers,
/fuad
