Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51988152193
	for <kvmarm@lists.linux.dev>; Mon, 13 May 2024 13:27:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715606822; cv=none; b=Lb2ddiiXHhrK2lkO72Iqo5UeOrlfgRNQj7Ygy0ewkm8yohxOQOgW3xEpkhm1PqhUJN5QMpcC7ss3PGF0+LOQm3MkWC+OpZKMeyudhN1t/cF7dGpqn8tTCj3JaCJtIj9B7eFL54XiG3mG4y6N5I63Zq4UdyqXsOkNTBcbI7GJTuU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715606822; c=relaxed/simple;
	bh=MEzUdxUhfY1RRiLXx4z2pKJImSLFBalpqmWr4ipWXR0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=l9/zm5ep454etyesEOXH1lCDqMP+rNoTsnUyIRwCM7UYaEDqRcPpHEhtGin9zwcnu/N2tDOYqgHcTBGZS0udQFUpJEj71QiYtn0WAV6xkhNetJ08NklhrmjJkEpIAG1SZ/kEEzpfInmsZrtaUyyygDbnAibw+OAyKiFecHu8nqY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=cNf+rU97; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="cNf+rU97"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1715606820;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=MEzUdxUhfY1RRiLXx4z2pKJImSLFBalpqmWr4ipWXR0=;
	b=cNf+rU971USGJs+3EC3lvLccyS2o3ncTOjQE++AwrozZrB+skSJyzVH7hScuQgBofcQ6TZ
	kavhMS+JxqtzhazX+yyUrIS6yyPkXEOzSuRMHd/piRDyrr0OJ5B8eV9gBqHSBD63NtM4rV
	L0IN0b70RdEXmWDmZ6t9gNBvi09f9iI=
Received: from mail-qv1-f71.google.com (mail-qv1-f71.google.com
 [209.85.219.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-264-K8B0tG-lNbeeo4SgUn8DAw-1; Mon, 13 May 2024 09:26:59 -0400
X-MC-Unique: K8B0tG-lNbeeo4SgUn8DAw-1
Received: by mail-qv1-f71.google.com with SMTP id 6a1803df08f44-6a0b7ebba6cso65458016d6.0
        for <kvmarm@lists.linux.dev>; Mon, 13 May 2024 06:26:59 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715606818; x=1716211618;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=MEzUdxUhfY1RRiLXx4z2pKJImSLFBalpqmWr4ipWXR0=;
        b=ckK2o7k2O99qvGJyznLpNlwgJWKd2Uwkq1TFpQgQgGJkfx1LlBWUkHusm1QeHckTMZ
         +kKur4fPjIGZD00AryYaO9vGJua4hOjpjD+BKOoVm8ELXITH7+/BOKP9SjESK0z3FbJc
         /zEEF1508vC4kzpEbdORibbWjT3p3hU9gq0HEb6vFFBQvgCbMnXm/5o67NfyvzTOP4k4
         1/eP3ii5zGVkPwmqyNErFhMa3U4fJ2Wq6YsizeH/QZr55AmvdW0PG3G7iCuMB7F1xcri
         67kcrG/CqFZLNBmX3FF9kbVOsmqqs1cWqVg9H/EdTA7LJdLtWtX/6bLF2anb7dTs4ch0
         FJaQ==
X-Forwarded-Encrypted: i=1; AJvYcCU1K+Nl+8k8Pg6vtGgQ9qfLHOJdXIcU+qkhPNWrWANAJWYnGGRXoeV1oVRPhT9bLt6cg28z9KObo3fP4VmKw1x7vZxcDFHC
X-Gm-Message-State: AOJu0YyYg9E7A2pec9VrGPyDdyAqZwyG/wlvIYCsPOZhp7ewmcaXrQgD
	bwVKWeDLQVz/pYWTql/cuIxuDKiGKjvtfRAMWHZysB/MinCcd4UQMQNUQO7lhRpIG2vVC7ABKmH
	1IvYxN5tyCihI84+oVOHyecNPowurUPTUGAUiILB/QSZu6QgNc67RPA==
X-Received: by 2002:a05:6214:3d07:b0:69b:5576:49e7 with SMTP id 6a1803df08f44-6a1681f5588mr125169596d6.45.1715606818240;
        Mon, 13 May 2024 06:26:58 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IE/j+JjKCWE8cRoMDkq03QS6KhsAqgmIlUjNCdmfJge/OlxjxNjcM8A71gXRJX0XEXntsFzJA==
X-Received: by 2002:a05:6214:3d07:b0:69b:5576:49e7 with SMTP id 6a1803df08f44-6a1681f5588mr125169466d6.45.1715606817915;
        Mon, 13 May 2024 06:26:57 -0700 (PDT)
Received: from rh.redhat.com (p200300c93f4cc600a5cdf10de606b5e2.dip0.t-ipconnect.de. [2003:c9:3f4c:c600:a5cd:f10d:e606:b5e2])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-6a340d25a18sm3747716d6.40.2024.05.13.06.26.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 May 2024 06:26:57 -0700 (PDT)
From: Sebastian Ott <sebott@redhat.com>
To: oliver.upton@linux.dev
Cc: james.morse@arm.com,
	kvm@vger.kernel.org,
	kvmarm@lists.linux.dev,
	maz@kernel.org,
	suzuki.poulose@arm.com,
	yuzenghui@huawei.com
Subject: Re: [PATCH 2/7] KVM: arm64: Reset VM feature ID regs from kvm_reset_sys_regs()
Date: Mon, 13 May 2024 15:26:53 +0200
Message-ID: <20240513132653.14219-1-sebott@redhat.com>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240502233529.1958459-3-oliver.upton@linux.dev>
References: <20240502233529.1958459-3-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="US-ASCII"; x-default=true

> A subsequent change to KVM will expand the range of feature ID registers
> that get special treatment at reset. Fold the existing ones back in to
> kvm_reset_sys_regs() to avoid the need for an additional table walk.

Reviewed-by: Sebastian Ott <sebott@redhat.com>

