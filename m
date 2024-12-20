Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08EEE17BD3
	for <kvmarm@lists.linux.dev>; Fri, 20 Dec 2024 15:01:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734706878; cv=none; b=bbPnHklgB9oFkFsHL+puhmcXK9OlkdYjzqLqFpnj8beJtYNAcJ2RTiXLklk1fPDIdv1RpesWHnxbHYRzhLpKlWcvSQr47b8KrLFKttt0BBXUQYHmhVP2F8jEbkLfF3An0w2yIXdr7RGlMcm08LVhIiNIWF2/a3IuWDyxnw6MIaw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734706878; c=relaxed/simple;
	bh=FU8u7FgteP60R1LVsxBg0Y2jrMf1zurXaeJFrIqaxrc=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=KfI5l0yR0PZKvLumeTTlzKGaB+oCjQCAtwA8lKac+tEAWCYBUKniIoBY8sREvhD08KCl12eoJZwhtOgzcJwILzXQvaEAqNWZeoLhy84dNC0Af38J1hAD8eSSyMDeUcJi35LbH0zMhmndoRLT+KLUy/RmZJARrFOOeL8tGcmlXuI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=aq7TqP1a; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="aq7TqP1a"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1734706876;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=nZvwncwJOuHramMroFGr8eBsUbQp9V+RXkC2LSaW6Lg=;
	b=aq7TqP1aBwMvpgm6udG7x+SqYvB08OKQdTT36tf6oqtwGKXPjCtCNUosU99RiqUQxkfCGG
	bcUQ3HtBsmbE92O2E5p43Q7JpuyzIh96SaSsD2Ba/5kU61RSeZedFBQw6V6oAgaCqutK+e
	TPl5aSDbgtyl8ex/W1THToFyMyeGkzY=
Received: from mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-619-JQCwutYbOvi5j9rBr_W_nQ-1; Fri,
 20 Dec 2024 10:01:11 -0500
X-MC-Unique: JQCwutYbOvi5j9rBr_W_nQ-1
X-Mimecast-MFC-AGG-ID: JQCwutYbOvi5j9rBr_W_nQ
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 292DD195605B;
	Fri, 20 Dec 2024 15:01:03 +0000 (UTC)
Received: from localhost (dhcp-192-244.str.redhat.com [10.33.192.244])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 3008F1956053;
	Fri, 20 Dec 2024 15:00:59 +0000 (UTC)
From: Cornelia Huck <cohuck@redhat.com>
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>
Cc: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>,
 kvmarm@lists.linux.dev, catalin.marinas@arm.com, will@kernel.org,
 mark.rutland@arm.com, eric.auger@redhat.com, sebott@redhat.com,
 yuzenghui@huawei.com, wangzhou1@hisilicon.com, jiangkunkun@huawei.com,
 jonathan.cameron@huawei.com, anthony.jebson@huawei.com,
 linux-arm-kernel@lists.infradead.org, linuxarm@huawei.com
Subject: Re: [PATCH v4 3/3] arm64: paravirt: Enable errata based on
 implementation CPUs
In-Reply-To: <86v7veppsj.wl-maz@kernel.org>
Organization: "Red Hat GmbH, Sitz: Werner-von-Siemens-Ring 12, D-85630
 Grasbrunn, Handelsregister: Amtsgericht =?utf-8?Q?M=C3=BCnchen=2C?= HRB
 153243,
 =?utf-8?Q?Gesch=C3=A4ftsf=C3=BChrer=3A?= Ryan Barnhart, Charles Cachera,
 Michael O'Neill, Amy
 Ross"
References: <20241218105345.73472-1-shameerali.kolothum.thodi@huawei.com>
 <20241218105345.73472-4-shameerali.kolothum.thodi@huawei.com>
 <86bjx8q995.wl-maz@kernel.org> <Z2RapzikZQGgeE_6@linux.dev>
 <86v7veppsj.wl-maz@kernel.org>
User-Agent: Notmuch/0.38.3 (https://notmuchmail.org)
Date: Fri, 20 Dec 2024 16:00:57 +0100
Message-ID: <87ikrebdqu.fsf@redhat.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 6LyvB_b7u5ZuUYY2BepSESaR96g2_bVq1DaUlhLgync_1734706865
X-Mimecast-Originator: redhat.com
Content-Type: text/plain

On Fri, Dec 20 2024, Marc Zyngier <maz@kernel.org> wrote:

> On Thu, 19 Dec 2024 17:40:55 +0000,
> Oliver Upton <oliver.upton@linux.dev> wrote:
>> 
>> > Independent of this, I wonder what we should output in sysfs
>> > (/sys/devices/system/cpu/cpu*/regs/identification/*).
>> 
>> It's a bit crap, but maybe implementation index 0 gets reported through
>> the 'main' midr/revidr files, otherwise have a directory per
>> implementation index of midr/revidr.
>
> Having slept on that one, I'm starting to think that we should keep
> the status-quo of reporting what the kernel snapshot at boot time.
> There is no good reason to force the VMM to report the potential
> implementations in any specific order.
>
> The "alternative-implementations" is interesting, but we don't keep it
> per-CPU, so I don't  think it fits the current scheme. But maybe
> something in /sys/devices/system/cpu, outside of the cpu* hierarchy?

I agree that this should be reported outside of the cpu* hierarchy,
maybe smth like

/sys/devices/system/cpu/alternatives/
   identification/
     regs0/
       aidr_el1
       midr_el1
       revidr_el1
     regs1/
       aidr_el1
       midr_el1
       revidr_el1

(with no guarantee as to _which_ triplet will show up under regs<n>)

Also depends on the intended consumers, I guess.

>
> Either way, this isn't something we should worry too much right now.

I agree as well.

