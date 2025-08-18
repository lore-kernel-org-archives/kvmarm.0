Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FA6B3218B9
	for <kvmarm@lists.linux.dev>; Mon, 18 Aug 2025 12:37:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755520661; cv=none; b=cXHeccdPpkZ1U9w0Mx5jKPMyWh7VqLDvyu6ThfHiQrsAvVupVKZEaHP8Qkd76vxE7qXdXb5SiJU34enpkp6D4oLp6UECOf4sH5Vy+oJdVtwVMewRizI/Uds5FrauvTpaRaf0FKcFKKqjdZ36bhGNONm7RTBL57Fai2pDkfH+Hk4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755520661; c=relaxed/simple;
	bh=vMg4Ou+izBv48m1C4+7AACR/UcTqtZSOITCf5JH+1yU=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=Xd9L1tgg1cGrcqGyzmGhV7RLspSojFFpb+2PHZsk14a8aW/XGOgUj4NY4HmvYc0Fo4pbpxCqEKVxOCVM/EDLhvEC3sO1ITZeJb+PDuq95GhLBiYn/W+tyhszJbnAd2nIHL1w4oLyzcIhj1JKjxnLYAP8tTt5k5YQymAVdiVQz9U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=GLGnjI7n; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="GLGnjI7n"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1755520659;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=B2qOgp7MVZuSP0Gl2TjLKxdK/FGouEDQU4SdWnp2yrQ=;
	b=GLGnjI7npoLIBLK1F91ruJeufqZh+i7s6pNcAmZUxsv7YGThRmhn4MTYMZRShtNY8Gvqfa
	4+MLC+UCcOYFxVCmVuSqSFy6O6t6cv/Id6yx8quZOiLWEtFYT4nE1RDGZz3DmzBwTUvg2h
	J9rhpHu4F9puwNxz/A5KrcykygzLyWk=
Received: from mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-183-Mz0j3rQXOCSl0HAgxQ7KoQ-1; Mon,
 18 Aug 2025 08:37:37 -0400
X-MC-Unique: Mz0j3rQXOCSl0HAgxQ7KoQ-1
X-Mimecast-MFC-AGG-ID: Mz0j3rQXOCSl0HAgxQ7KoQ_1755520655
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id CFBEA1955D6A;
	Mon, 18 Aug 2025 12:37:34 +0000 (UTC)
Received: from localhost (dhcp-192-216.str.redhat.com [10.33.192.216])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 73BC71955F24;
	Mon, 18 Aug 2025 12:37:33 +0000 (UTC)
From: Cornelia Huck <cohuck@redhat.com>
To: Marc Zyngier <maz@kernel.org>, kvmarm@lists.linux.dev,
 linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org
Cc: Joey Gouly <joey.gouly@arm.com>, Suzuki K Poulose
 <suzuki.poulose@arm.com>, Oliver Upton <oliver.upton@linux.dev>, Zenghui
 Yu <yuzenghui@huawei.com>, Will Deacon <will@kernel.org>, Catalin Marinas
 <catalin.marinas@arm.com>
Subject: Re: [PATCH v3 4/6] KVM: arm64: Make ID_AA64PFR0_EL1.RAS writable
In-Reply-To: <20250817202158.395078-5-maz@kernel.org>
Organization: "Red Hat GmbH, Sitz: Werner-von-Siemens-Ring 12, D-85630
 Grasbrunn, Handelsregister: Amtsgericht =?utf-8?Q?M=C3=BCnchen=2C?= HRB
 153243,
 =?utf-8?Q?Gesch=C3=A4ftsf=C3=BChrer=3A?= Ryan Barnhart, Charles Cachera,
 Avril Crosse O'Flaherty"
References: <20250817202158.395078-1-maz@kernel.org>
 <20250817202158.395078-5-maz@kernel.org>
User-Agent: Notmuch/0.38.3 (https://notmuchmail.org)
Date: Mon, 18 Aug 2025 14:37:30 +0200
Message-ID: <87tt24erg5.fsf@redhat.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17

On Sun, Aug 17 2025, Marc Zyngier <maz@kernel.org> wrote:

> Make ID_AA64PFR0_EL1.RAS writable so that we can restore a VM from
> a system without RAS to a RAS-equipped machine (or disable RAS
> in the guest).
>
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/kvm/sys_regs.c | 1 -
>  1 file changed, 1 deletion(-)

Reviewed-by: Cornelia Huck <cohuck@redhat.com>

