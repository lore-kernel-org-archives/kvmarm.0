Received: from mail-ej1-f43.google.com (mail-ej1-f43.google.com [209.85.218.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24F1B38AC65
	for <kvmarm@lists.linux.dev>; Wed, 10 Jun 2026 09:27:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781083627; cv=none; b=FVxVLCfc84kKGboCr0LzEmWPMro56a2EcvWgu0ljb0jqK7inlMM466WNt01VjzKQDasTM6GyShzhPnpH9ksoljBxIa/E7NmIesJ7wnAaUlNQwXF48m9yAVkh0ZKjC3ShjAXH05NgszVdiEpND3+uttQomQ3bdT60UdlR9ZHzgtQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781083627; c=relaxed/simple;
	bh=Rvvl0zHsRKXsyvcXHZS6F+yj7/26A7hm2pQ/uWdBJt0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kanBvFQPrGdcQVHoB1oMqUOV250BSE72U3+3UQtkf9xNJbTpNznRaOkMT3mYJkOCGs2a4vZUNmyD7g8b6g56JJycjGHFSmuxTzNPqtVJN1RmJTup2eg+ineUFAZu7TIkvy9dqaM9wewDzYAnwmsuJ/0S7O7TRyx0X2vImrrae1I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=QFmCyDr3; arc=none smtp.client-ip=209.85.218.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="QFmCyDr3"
Received: by mail-ej1-f43.google.com with SMTP id a640c23a62f3a-bf84a2b2077so342742266b.2
        for <kvmarm@lists.linux.dev>; Wed, 10 Jun 2026 02:27:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1781083624; x=1781688424; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=/a+aF2FASI2PrgPXKTQczzpNoIJIj4s5NhzwmvJ4C9o=;
        b=QFmCyDr343pK1tr902+QyWNkm1/SfdjKEwTAZpkWqfaaXlbczXKcKmpUi/A1Rs118k
         +PdijIM5EOXVrEjPT76IDRSp5nrXJgNcEELFbdPR4gmgxtv+CkdN78Jd9OzjCHUjCpWT
         1xzFiIUYQLh9MsaIi5ob1HhrtmsyhnjO+Xg6BlIAg7A3ezLpbe/9srVOnVhp7VcUf+bt
         kSEm/4frv2UR85R+qyAHhbi5PDPH0XTeQlD+jwhbovNeSvZykq04J5ghv7itaHavre2s
         AG7C4/uHqbo3wcCvl9+CX5ROX8xmux4GW0ifRu5rzRWB5CMvHg8Mg0wjLJ/mNS8c3Nsa
         mXrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781083624; x=1781688424;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=/a+aF2FASI2PrgPXKTQczzpNoIJIj4s5NhzwmvJ4C9o=;
        b=YXrqx52rM1Mopq0z6BgiYcm9caxApNm7AL8TsrX/UtKcsve/nb+Rnpj6bxQ+YLGFJJ
         rRpKsHqNYODG4slMrmxD8BQmCier8QDGvXIk7aFba2Kzq+lKw8gIOWkeZKDzHBiFpHtf
         VbbAsbu6cat7/xI6khpDbZIUi1rEsNixmDVwMCAJaRV9JIQKIrDxNGdjEWaZ8LK6ffw0
         smPwcIQAiEy1XMt2CvWSeZHjR1AN6A/gQmsb+1ZOiMzqSRqIFMsxf3/BpaLWO8h6xdZ2
         bufCxDT8q+Ulyh2Umh4+lBb3mJA3ZeRgRteW+zRK0qWTp4sBkEeOlezvPI0uGcM1vi2x
         I4tg==
X-Forwarded-Encrypted: i=1; AFNElJ+s1Uo0NIVUl1ozYkoYwkNesQ4W4e34mXVMqg72rBzoUonDHSGT24k/TBI/FWfsTVfTfAp6PZo=@lists.linux.dev
X-Gm-Message-State: AOJu0Yyn/EkBgfNgLMcpVr5eYuJUNQ68fm9lAWK0lOUG1opDJxxS+2iW
	F7mlB+GP5qHANFVD7BQbxE7VCFYNsex6bEvdCjApFRbWeFh2NCnn34OX64MIfRaQ1A==
X-Gm-Gg: Acq92OGjAT5OKJmdNcfSfDevvDl0KNKvpkLzZzn/a0VPyZljHcA6ikKO+a4Bk7EGJs6
	ieUUvbE1cD1mBuK1gG8G0B1VXHgKiYIxXC/gswSBY5uT0x+e3pKBkxHE10Zn3mCyJJrBQhAsXk3
	BShzJnR463wKOsJCULGgpifpfblgZS8jvDqIwKaQ9EFepIemfIRXeNv/zAP9IOJWV7aw1vY1ubL
	JPQfyxOiWRkDI1/O3qs9EQz3mIR0IW033/crnKfn9p2OBgTmy524E8bdxU2hxypa4V0SSxOJHul
	k+SA90Ogec5igWrpsAC7uuD/IwSJX6d7kSLUu+57p3kBRzA1xu/AfjCp5igPfviEOo3mjfaRAu5
	7eN3FjETYASTRsyAW9aSrU2vSkmzkv8vrWk0LZozImMuf745ILEqXOzhjCcbjCRT0VpmHmmg1f+
	wLwsqDn43OoyjxFSCHXyDCypLws8hFD5oe4FtWULWm1P3rQ/NhdisBrF2Px1FK7rHd3rc52WqjE
	EMsEGOWEBvYE3db
X-Received: by 2002:a17:906:794c:b0:bee:dce5:739d with SMTP id a640c23a62f3a-bf3749d4005mr1209578266b.49.1781083623847;
        Wed, 10 Jun 2026 02:27:03 -0700 (PDT)
Received: from google.com (135.91.155.104.bc.googleusercontent.com. [104.155.91.135])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-bf0522834dbsm1145247966b.27.2026.06.10.02.27.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Jun 2026 02:27:03 -0700 (PDT)
Date: Wed, 10 Jun 2026 10:26:59 +0100
From: Vincent Donnefort <vdonnefort@google.com>
To: Sebastian Ene <sebastianene@google.com>
Cc: catalin.marinas@arm.com, maz@kernel.org, oupton@kernel.org,
	will@kernel.org, joey.gouly@arm.com, korneld@google.com,
	kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org, android-kvm@google.com,
	mrigendra.chaubey@gmail.com, perlarsen@google.com,
	suzuki.poulose@arm.com, yuzenghui@huawei.com
Subject: Re: [PATCH v2 0/7] KVM: arm64: Forward FFA_NOTIFICATION* calls to
 TrustZone
Message-ID: <aikt44sVnpL3_dYi@google.com>
References: <20260608165549.1479409-1-sebastianene@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260608165549.1479409-1-sebastianene@google.com>

On Mon, Jun 08, 2026 at 04:55:42PM +0000, Sebastian Ene wrote:
> Remove the FFA_NOTIFICATION* calls from the blocklist used by the pKVM
> FF-A proxy. This restriction was preventing the use of asynchronous
> signaling mechanisms defined by the Arm FF-A specification to
> communicate with the secure services.
> While these calls are markes as optional, there is no reason why the
> hypervisor proxy would block them because:
> 
> 1. Host is the Sole Non-Secure Endpoint: The Host operates as the
>    only Non-Secure VM ID (VM ID 0) recognized by the Secure World.
>    Because all forwarded notifications are inherently attributed to
>    the Host by the SPMC, there is no risk of VM ID spoofing
>    originating from the Normal World.
> 
> 2. No Memory Pointers or Addresses: The FFA_NOTIFICATION_* ABIs
>    operate strictly via register-based parameters, passing only
>    VM IDs, VCPU IDs, flags, and bitmaps. Because these calls do
>    not contain memory addresses, offsets, or pointers, forwarding
>    them doesn't pose a risk of memory-based confused deputy attack
>    (e.g., tricking the SPMC into overwriting protected memory).
> 
> While the pKVM proxy behaves as a relayer, it doesn't currently have its
> own FF-A ID(only the host has the ID 0). The behavior of the setup
> flow is covered by the spec in the: '10.9 Notification support without
> a Hypervisor'.

As it is only a relayer. Is it really important to check SBZ arguments and
fields on behalf of Trustzone? It doesn't feel it brings any security. If the
host passes broken arguments, I don't believe this puts pKVM at risk. Does it? 

> 
> ---
> Changes in v2:
> - enforce the MBZ/SBZ fields
> - split the calls into separate patches
> - rebase on 7.1-rc7
> 
> Link to v1:
> https://lore.kernel.org/all/20260501114447.2389222-2-sebastianene@google.com/
> 
> Sebastian Ene (7):
>   KVM: arm64: Support FFA_NOTIFICATION_BITMAP_CREATE in host handler
>   KVM: arm64: Support FFA_NOTIFICATION_BITMAP_DESTROY in host handler
>   KVM: arm64: Support FFA_NOTIFICATION_BIND in host handler
>   KVM: arm64: Support FFA_NOTIFICATION_UNBIND in host handler
>   KVM: arm64: Support FFA_NOTIFICATION_SET in host handler
>   KVM: arm64: Support FFA_NOTIFICATION_GET in host handler
>   KVM: arm64: Support FFA_NOTIFICATION_INFO_GET in host handler
> 
>  arch/arm64/kvm/hyp/nvhe/ffa.c | 190 ++++++++++++++++++++++++++++++++--
>  1 file changed, 182 insertions(+), 8 deletions(-)
> 
> -- 
> 2.54.0.1064.gd145956f57-goog
> 
