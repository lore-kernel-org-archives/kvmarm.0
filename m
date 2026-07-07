Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 444CB175A7F
	for <kvmarm@lists.linux.dev>; Tue,  7 Jul 2026 00:56:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783385775; cv=none; b=rhDKyGaBY/pPPlsJhdhf8uUpv6X2dHkh/0HakLIl8BiWGegfiR06w6CNIUJrUuor6YlrJWT/ZU7aBg+Khb+o0Gtvu0jDJCIuyXBMhyCbX4yY3RVfjB52OP4Uie6o+edKFYef/QZBEy+bMxsedgFOIUvggQ0uMHmOGmPfMWbSDRc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783385775; c=relaxed/simple;
	bh=2ElyoNTjNvCHsolLm4ZPm+IBRz5WRZTA02wMyFsRuC8=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=P0Lrj3r+V5j0fqL20b+n/Xp/hv21Ijk7b9K+zWDsMdP/Mnca+GxMLbFDl0g9vF4+upNsnvheDCbAR6TdF7uZ0G/ZUu33oQPrNXWGuL7pouDj5llfw4foiKdoGa9EWD1ttHrDoV2Im8HaxSxU+K0esN1Ieo7bVKRYocD+9IBMV6o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=suKcaMfM; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="suKcaMfM"
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-2c9ed5caa3bso1844585ad.1
        for <kvmarm@lists.linux.dev>; Mon, 06 Jul 2026 17:56:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1783385773; x=1783990573; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=VxNhNQGund/YZNpVTOrvdeVh/HxeApY5VkBlX3NJ2Bs=;
        b=suKcaMfM5zWTa1/QZbDdH/asjf4sw8LrQjFO4PmRnFbJQWHLeQ+OQ7HK1rbJ5Monea
         QY8EHCElSFhedT4KU7cZx1EzbSvy8tt6Kqlf/gro/Voi2cohSaeC/pZJ2VYKla0RdyBT
         zYxiO1XM/stOZMBL2YLu9gdea5xTA3KessV9YDOu2fWuKbT/e091mAoOauDvbOpuS0g1
         r5+2gWl6LkXcbAmG0GoNdVdfeGdv120tdzts/sf/PYAuImQT+qK0b2iL6wcjANCKsalR
         RaZRz38hM9F0i1PPLOQfCQizsUBU1zHQ3NA+Fu5m9NMyWrmYVI1sRumZIqVRt+CwhqxW
         z5+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783385773; x=1783990573;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=VxNhNQGund/YZNpVTOrvdeVh/HxeApY5VkBlX3NJ2Bs=;
        b=NoW2RVLzYzYpFufetruAPn9zyB1c3lBxVRjJpcPK2hPhLpaV1Y8eFhEF5xdHX3PmYX
         0JT3vQft6Mmj61wTgBM5rXrPg1MS4y9C+fFm699BDX1A6QaJZ0ii+piRloyPOs+++Gb3
         kaNpCcEOVbjIfepGO+5OJWiIVaBQ4nZJTQGkm/2nHgCxLQzCkYnvkVsx+RFWr0WOtJfh
         kPPmTZMecL40nTo/vK/+W7OFRvcH/y7nfcvp+hy5LiqPw1biHdI8CCqoQSFk+7w9rovO
         WjfUZZ3vCUYlOUAZ6zX+RihokJFLxpSmZoSssYrpH/jmM+j22iBRmIZ72qCypO37ChJq
         kVvw==
X-Forwarded-Encrypted: i=1; AHgh+RrcQ2p3y+DTtpL4K6dD6DY1ywmVi7dVV+IlzTYD3SRlzbmdpZ9/W42Reu5dJMC7OJbY9I9kyuw=@lists.linux.dev
X-Gm-Message-State: AOJu0YwLo/2trP/b3wFDD2UKy0A5f2+5/wu2NV3GP7dZeQjyx4g5HaiQ
	YYjSXA/5jV8q5b+zxjUVFgAMQ05/HUqpGkLazR7bJWS0pUXS9TjQ2IhJGRPBFZiCpD1IymYyAHj
	hBPpDNQ==
X-Received: from plwg16.prod.google.com ([2002:a17:902:f750:b0:2cc:7ef7:ea41])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:e883:b0:2c9:fc0d:165b
 with SMTP id d9443c01a7336-2cccade45e7mr5481825ad.23.1783385773032; Mon, 06
 Jul 2026 17:56:13 -0700 (PDT)
Date: Mon, 6 Jul 2026 17:56:12 -0700
In-Reply-To: <20260702142912.6395-1-alexandru.elisei@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260702142912.6395-1-alexandru.elisei@arm.com>
Message-ID: <akxOrMnlNga-vtQv@google.com>
Subject: Re: [RFC PATCH 0/3] KVM: Dirty page logging for guest_memfd-only memslots
From: Sean Christopherson <seanjc@google.com>
To: Alexandru Elisei <alexandru.elisei@arm.com>
Cc: pbonzini@redhat.com, kvm@vger.kernel.org, david.hildenbrand@arm.com, 
	maz@kernel.org, oupton@kernel.org, joey.gouly@arm.com, seiden@linux.ibm.com, 
	suzuki.poulose@arm.com, yuzenghui@huawei.com, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	fuad.tabba@linux.dev, mark.rutland@arm.com
Content-Type: text/plain; charset="us-ascii"

On Thu, Jul 02, 2026, Alexandru Elisei wrote:
> The memory represented by guest_memfd-only memslots
> (kvm_memslot_is_gmem_only() is true) is shared with userspace, which can
> freely mmap it and access it. The only thing that is preventing dirty page
> logging for such memslots is that KVM doesn't allow slots backed by
> guest_memfd to have their flags changed; they can only be created and
> deleted.

Please (publicly) document *why*  you want to add dirty-logging support.  It's
all but impossible to review new uAPI without knowing the use case.
