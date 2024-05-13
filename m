Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 862F4152171
	for <kvmarm@lists.linux.dev>; Mon, 13 May 2024 13:24:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715606670; cv=none; b=ii3TJyuipIsL6sF9rQ13fK5XT177qGkN+EW5pxUguvxmHZRG7pQSs0/jLGImyacpVI+VVhJXHOJzhxSEaAiJu1IkF07ubsUMqxCE0MKLLi0t6TevaBfSpo6axiR78Z8SMa3WKd3pueh6n1v+HuVWjwkSLjOFuQp8v/hvhIP3iao=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715606670; c=relaxed/simple;
	bh=jWgwDMmhPr51PSrvy3HxwSLmzIln6gb49e+7ScKUKaI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=SBgNp9vLzYRjh1GnRr4xpw0UK1efbQdduL+KnJ6Q9jBh97C1HegjRYVyouVPNfr3i7YlHM7FDHEodIc7MfwzS0xCGWsvg0VsIptFHxo/Jf6vGAV/V/RgvA5GfNmLDNOKwLt9DK2QqQ0Kyz8DkPORf52p8dQ2i2WvKQNISLVHOn8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=LCj8Grjr; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="LCj8Grjr"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1715606668;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=jWgwDMmhPr51PSrvy3HxwSLmzIln6gb49e+7ScKUKaI=;
	b=LCj8GrjrnycwK7XVL1m5LaDCYKUVBlBzAvhVR1TfoDw69DoydSq2U0XzX/UwWDkdJMaQXs
	iuMtU5j0fPNIoe41yAW4zk6WphzLhxReQfP5B6PrxpSVEw0dEuh3Lu3ZUZiIgHKa25ltZt
	8CbtZAYgzUHiKqH4nEt9+aG4j5LMNBY=
Received: from mail-oi1-f198.google.com (mail-oi1-f198.google.com
 [209.85.167.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-103-UxmmrGBSOOmC5GWxKZlh6A-1; Mon, 13 May 2024 09:24:17 -0400
X-MC-Unique: UxmmrGBSOOmC5GWxKZlh6A-1
Received: by mail-oi1-f198.google.com with SMTP id 5614622812f47-3c9af44fdbeso521344b6e.3
        for <kvmarm@lists.linux.dev>; Mon, 13 May 2024 06:24:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715606656; x=1716211456;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=jWgwDMmhPr51PSrvy3HxwSLmzIln6gb49e+7ScKUKaI=;
        b=QlqJCNqeZwEfsQeNicxBTZXIwRiUH11cUQdosFdDJyjxXaDsfD98w93XggVBHFQWbz
         oM2FZbeAemwUWSDd8IDMVl8n0xkW7KxTI6IBtqmyWMcnprwFo6atq90p1hlex9aZa+Hc
         Igs6CIYV0i1vFlYSps1908w9GVlt3d9bE4jDitR+L+NGfw4Z1NcL0hwt60CuqfqOHCxb
         3AHmTod3zMw5AZz/8CRwPCjzjnD5hxzQS21BB6tCzPvMwmghXXPDiZO4IeEO5S7gbHwF
         sSW0P57rx58n8QU/mX1FhEVdvDKJzB6VeEUzcYQJ79IZjdSB5h6Us9xBvY7xVxLMreTW
         Si7Q==
X-Forwarded-Encrypted: i=1; AJvYcCXbgsM6QYhGae0lugQP9U+ZdizgguTSOPudobcz4pNKYYndoSpDBm5dfwG9U8PVSOn2r+lizPCJDtB1dcU1UwwFATnWdomf
X-Gm-Message-State: AOJu0Yw0BE8xuKXaRa4sFiGhbPo3RkhyDBK7lLaKMtbgilYxEFLIYzyr
	mQd6GITYfAhuot7Iwe3u2fJrFhfqLHv1jK40e/Ws8pbdLM2lsV+OuexTKqx3/rW4AwRRl5+5NT7
	KDssn88bOVc6Yl5WIAJEULm1nButoeAqWEwEYbHPRvQNBmXLwXrBltA==
X-Received: by 2002:aca:230c:0:b0:3c8:4aff:649b with SMTP id 5614622812f47-3c9970cf848mr12498551b6e.41.1715606655955;
        Mon, 13 May 2024 06:24:15 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IE1SJBjApdI9h30qN1A1Ax9CGL2jjZnJns6O/3RadMVtbnCEbV/aF8/UeID/yOoTqYATTt3Gg==
X-Received: by 2002:aca:230c:0:b0:3c8:4aff:649b with SMTP id 5614622812f47-3c9970cf848mr12498521b6e.41.1715606655586;
        Mon, 13 May 2024 06:24:15 -0700 (PDT)
Received: from rh.redhat.com (p200300c93f4cc600a5cdf10de606b5e2.dip0.t-ipconnect.de. [2003:c9:3f4c:c600:a5cd:f10d:e606:b5e2])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-6a15f203e21sm43077366d6.136.2024.05.13.06.24.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 May 2024 06:24:15 -0700 (PDT)
From: Sebastian Ott <sebott@redhat.com>
To: oliver.upton@linux.dev
Cc: james.morse@arm.com,
	kvm@vger.kernel.org,
	kvmarm@lists.linux.dev,
	maz@kernel.org,
	suzuki.poulose@arm.com,
	yuzenghui@huawei.com
Subject: Re: [PATCH 1/7] KVM: arm64: Rename is_id_reg() to imply VM scope
Date: Mon, 13 May 2024 15:24:11 +0200
Message-ID: <20240513132411.14102-1-sebott@redhat.com>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240502233529.1958459-2-oliver.upton@linux.dev>
References: <20240502233529.1958459-2-oliver.upton@linux.dev>
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

> The naming of some of the feature ID checks is ambiguous. Rephrase the
> is_id_reg() helper to make its purpose slightly clearer.

Reviewed-by: Sebastian Ott <sebott@redhat.com>

