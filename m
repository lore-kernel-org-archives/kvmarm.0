Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46FC270831
	for <kvmarm@lists.linux.dev>; Fri, 14 Feb 2025 16:12:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739549532; cv=none; b=h5UBydmePqFKMUufw1fGebyFC9pqo9AvY8sd5HbpdAh55oAnAyiY3En9+ieqV++iHNYXBPgFRzXnIUiR9qf03IRMANmE3s0uSnsuoUa84sErtUfFAtVxEGQIVTsTjo+JA7RXFhukEIYFP3qvxrmH0ZMUd14Citize6PKjdjbM5w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739549532; c=relaxed/simple;
	bh=9rU4kAK02kLzV6QdIIG9KIbvsHX1G28GJXyl8/6kQ9k=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=TU8DDmZnNV6V4wqFm6k84A0nqv159aHxIZkUx0Mq+IKD6ltL60Z7ixRt3aFXJIiqfze/7/74LqLUyVrBpCMzKQylwoBtD4ClUVSmZ+agX4fE2ev0GlQJpCVDGElx4JMiLh2P+EZ6drNFS6VYcDcoMUMgiBpFLcao+Ut9q8Ol2tk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=NAZ5wlc3; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="NAZ5wlc3"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1739549529;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=9rU4kAK02kLzV6QdIIG9KIbvsHX1G28GJXyl8/6kQ9k=;
	b=NAZ5wlc3BawIv0tS40AsTy6cFl5p8ne+39gUXjWhDSfvnjclc85s3UxROHqJErUdoRP3ll
	gXRBc0sn7gJI33nTvooG+voIxRRgO2Q0chGzLJEiDM2MH+BYzkZ+H7LSIl8kMM2t05vNr3
	d4CwHmeYR+V5ybmB4YJQ+0hg1DXQeM4=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-630-clDo_r7gOK6ncV9o0wL9bQ-1; Fri, 14 Feb 2025 11:12:07 -0500
X-MC-Unique: clDo_r7gOK6ncV9o0wL9bQ-1
X-Mimecast-MFC-AGG-ID: clDo_r7gOK6ncV9o0wL9bQ_1739549527
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-38f2f438fb6so800252f8f.1
        for <kvmarm@lists.linux.dev>; Fri, 14 Feb 2025 08:12:07 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739549526; x=1740154326;
        h=mime-version:references:message-id:in-reply-to:subject:cc:to:from
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=9rU4kAK02kLzV6QdIIG9KIbvsHX1G28GJXyl8/6kQ9k=;
        b=GgJhYkRlkdTVIq5cEOyMNFBiLC/CbIHKhltB095/YS3re5WYnQY+XDMYCb5rf8UwRW
         I2NL0Ceg/NmxV9Lz3vEhap5qS84QtLbtQHUFZSjjmKvof6geP6EzbpcKec9GIHU6S7W7
         eoFema/TKW5OM1o0wc4xEL4Xi08kW98Yet/uBIpTqCOR23V8IKlV1bgDNmLcErx9A4yE
         AYe+exdlt+XV8R8DOnkA7y9Xpm/RkmT9bflxQQf3TciVzBfS/xvnv2lrRJXnK0e4i1ep
         HEMJuT1YPVdp6xNN5jCutA1N+OuDG7boBiHgBd0c+m1ECgqJY6cT/FVStA8Usx/2A2gm
         sBWw==
X-Gm-Message-State: AOJu0YxxcHk0VT0k8hMh5rew/+QYsQqbboLpAe1ZAtFGUcuod84eaacW
	2nnekfj+s36t82ec82RF5kCrovcrILMhV0ixN3nAi2pEya9NIUo+FpPagZjIvU5LoEqmOiM3XyO
	bSGnHdwY7xTD5GjbQszwDZ9uTh3/o40+1r/dP8IRx53otX7hwxpd8yfVaeh8Ntw==
X-Gm-Gg: ASbGnctfWcn2UbEIB9NlG/GY5GaKhuRTk+egu7LQ3FltDLnBqkIkKUvPHmtG8KQf/jt
	ZeawehP/3WnLN0i9j5oTaENQ8rH9G3Tok1oHl8JeP/Jt7W3U+LLTttxO1jm+AI3ImiiSyYw1o5o
	hwTvQvq1pAKo3+XR8Aq8lI1cg9imyya2azfN2HPKXnjZwBkzWVAqwwPJPDuGkii243PY3a8hRra
	GeD9wTCxDt6uohOj+wsDtbc6NTgADX7mrVyBcOHQUuwLbTbAWpj6IqnBoeCH7PLNzF8PA8Snaon
	T58xCt76YDBMlHxHXu/OW+gu8JIIG+Y0bh/g8a3uqreDIaTUNA6umQ==
X-Received: by 2002:a5d:47c8:0:b0:38d:dbbc:3afd with SMTP id ffacd0b85a97d-38f244da0c2mr13727880f8f.10.1739549526203;
        Fri, 14 Feb 2025 08:12:06 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEcI2NzAuNSVbBparnUO5fYVfOX53USB+DDuRh2f8jycwPKynNSN38Usb2CLponDOD4RENz1w==
X-Received: by 2002:a5d:47c8:0:b0:38d:dbbc:3afd with SMTP id ffacd0b85a97d-38f244da0c2mr13727588f8f.10.1739549524323;
        Fri, 14 Feb 2025 08:12:04 -0800 (PST)
Received: from rh (p200300f6af0e4d00dda53016e366575f.dip0.t-ipconnect.de. [2003:f6:af0e:4d00:dda5:3016:e366:575f])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-38f258ddbbdsm5022784f8f.37.2025.02.14.08.12.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 Feb 2025 08:12:03 -0800 (PST)
Date: Fri, 14 Feb 2025 17:12:02 +0100 (CET)
From: Sebastian Ott <sebott@redhat.com>
To: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
cc: kvmarm@lists.linux.dev, maz@kernel.org, oliver.upton@linux.dev, 
    catalin.marinas@arm.com, will@kernel.org, mark.rutland@arm.com, 
    cohuck@redhat.com, eric.auger@redhat.com, yuzenghui@huawei.com, 
    wangzhou1@hisilicon.com, jiangkunkun@huawei.com, 
    jonathan.cameron@huawei.com, anthony.jebson@huawei.com, 
    linux-arm-kernel@lists.infradead.org, linuxarm@huawei.com
Subject: Re: [PATCH v7 4/5] smccc/kvm_guest: Enable errata based on implementation
 CPUs
In-Reply-To: <20250214151343.61348-5-shameerali.kolothum.thodi@huawei.com>
Message-ID: <10831a79-a21f-dc40-a374-81b300d26dac@redhat.com>
References: <20250214151343.61348-1-shameerali.kolothum.thodi@huawei.com> <20250214151343.61348-5-shameerali.kolothum.thodi@huawei.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: Es4NwQNob53maea4RNkjV0imgxlol8ZfMzD7g_402Tw_1739549527
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; format=flowed; charset=US-ASCII

On Fri, 14 Feb 2025, Shameer Kolothum wrote:
> +++ b/arch/arm64/kernel/cpu_errata.c
> @@ -14,6 +14,9 @@
> #include <asm/kvm_asm.h>
> #include <asm/smp_plat.h>
>
> +u32 target_impl_cpu_num;
> +struct target_impl_cpu *target_impl_cpus;

These should be exported (for configs using
CONFIG_CORESIGHT_SOURCE_ETM4X=m)

Sebastian

