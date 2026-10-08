Received: from mta0.migadu.com (out-174.mta0.migadu.com [91.218.175.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5FF23B3C0F
	for <kvmarm@lists.linux.dev>; Thu,  8 Oct 2026 18:16:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791483390; cv=none; b=p4pcbR4nVCAnLs2i0lpFN3CUcJcIzmHkUDIABuW8xP2Zw3bNTFg+ixUGynKNVYqvTOM8GGcc1AVu1fDeIUUbPG9LxKMB6VkueM/OGTnGLXB8IMYRZEPHGKvs8a0zExM1I+iXrcvOyO1hX5nnJXRgMyJvCQ9+3nU+llJkJHgtO/Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791483390; c=relaxed/simple;
	bh=dJp6v2Ja1oAUDcBBY8lc+avUqbGTGsWO7LV2V6N9F2w=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=MohFzOvH3N/WcP7Or8s1yRLR4wdf+GvLZj5kglHpvPH4VwyOjc+2jr9qeZr4EhDfiE7No3koQd1B+H0uOGl/IZ5z84T7/0d73poY/1ibtdseHAULPgC+Y5UCazGqNhamZ+JrSgFgifBN9+bgLBpPbuk7c4tKOJw6pQdBf25Fyx0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=WiZIbIq2; arc=none smtp.client-ip=91.218.175.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="WiZIbIq2"
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=dJp6v2Ja1oAUDcBBY8lc+avUqbGTGsWO7LV2V6N9F2w=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1791483385; v=1; x=1792088185;
 b=WiZIbIq286qCBee3rLqImrYWB3inlVFH684k2JGyMpLc6odBlS7lJViNtSBA5FbCiXvPYXFV
 sF18B5oAHALyCRWQIkGLSjkwi/F1ZlTImrWW6OGywystMD6+eAbtmE6N5C0CC+TO+aFZVx+t8LA
 9gVjtmdd9mM0AKBHDOoeFbKM=
X-Envelope-To: kvmarm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id d4f163ed0f033873;
	Thu, 08 Oct 2026 18:16:25 +0000
X-Mizu-Trace-ID: d4f163ed0f033873
X-Migadu-Flow: FLOW_OUT
Received: by mail-lf1-f47.google.com with SMTP id 2adb3069b0e04-5ba40832934so1064e87.1
        for <kvmarm@lists.linux.dev>; Thu, 08 Oct 2026 11:16:24 -0700 (PDT)
X-Gm-Message-State: AFq9FYKhezC/A1d4kry9cfV9Y3l+KsNARKt0GWHtQk3JkC7dEgyY+b5p
	TWQSGpU86VcKDDuH6amK0NENjrOBHLYRyAYcx7Be6gjm+jtK+Y5ybxCz7msL9HbWXViXxkzukdq
	T/f8wRgo836cIqjDzZJnc5CZqI+RhB+Q4+LxgmzHY
X-Received: by 2002:a05:6512:ace:b0:5b8:f142:cf3 with SMTP id
 2adb3069b0e04-5bcd5890f4amr150542e87.11.1791483383492; Thu, 08 Oct 2026
 11:16:23 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260929093548.3598547-1-maz@kernel.org>
In-Reply-To: <20260929093548.3598547-1-maz@kernel.org>
From: Fuad Tabba <fuad.tabba@linux.dev>
Date: Thu, 8 Oct 2026 19:15:46 +0100
X-Gmail-Original-Message-ID: <CA+EHjTybnn2jgVKxCO0WXdGXWJ-=2p4k98CHfh3CrhJopvPDFQ@mail.gmail.com>
X-Gm-Features: AclHuK9F-CjG2RqTqPcpwRNH7SEKScgxMbDWuUjmfFIxGLGqlhC9PbSIglGCGAE
Message-ID: <CA+EHjTybnn2jgVKxCO0WXdGXWJ-=2p4k98CHfh3CrhJopvPDFQ@mail.gmail.com>
Subject: Re: [PATCH v2 0/7] KVM: arm64: vgic-v3: Make LPI disabling robust
 (and more)
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	Steffen Eiden <seiden@linux.ibm.com>, Joey Gouly <joey.gouly@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Oliver Upton <oupton@kernel.org>, 
	Zenghui Yu <yuzenghui@huawei.com>, Yuchao Zhang <ndaugoing@gmail.com>
Content-Type: text/plain; charset="UTF-8"

Hi Marc,

On Tue, 29 Sep 2026 10:35:41 +0100, Marc Zyngier <maz@kernel.org> wrote:
[...]
> Address the two issues in one go, by actively taking a refcount on all
> IRQs referenced by last_lr_irq, and making sure that disabling LPIs
> force all vcpus to be paused, making it safe.

I'm triaging Sashiko's pre-existing bug database, and I ran into
something that I think this series doesn't cover.

vgic_its_inject_cached_translation() doesn't check vgic_lpis_enabled()
(the slow path, vgic_its_resolve_lpi(), does), and pausing the vCPUs
doesn't stop an MSI coming in through irqfd or KVM_SIGNAL_MSI. So an
MSI that hits the translation cache between vgic_flush_pending_lpis()
and vgic_its_invalidate_all_caches() can still end up on the ap_list
of a vCPU whose LPIs are being disabled, after the flush.

Could the cached path check vgic_lpis_enabled() on the target vCPU, or
am I missing something?

Cheers,
/fuad
