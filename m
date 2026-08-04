Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 603594195DA
	for <kvmarm@lists.linux.dev>; Tue,  4 Aug 2026 06:51:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785826302; cv=none; b=H9tOO8Wv4uRZLdmsdwBmYekUlaSEopHhBavWycK7eDHpaPdrkXIH6DHpaU7tzrkhqrBihRpTLX4ongGct65ra7sRF7rBRjjhSsl1/XoNCWCvvB/ZxVdOPDeCKHi4J12BHRDjznOqaFdD3AnsSw/QJLlEDf3Yw3n+cuvgGCPe0VA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785826302; c=relaxed/simple;
	bh=U0TxdDEw/LAz1B7Pea3opMV+CJl+moS22Um0L+03GGA=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=hW0f+WeS8KCJx5F2l9Y8zHFo7hXAMgJykU/KGcN5d8L8hb6u+ZhSwRbOt6yYYVBTpi8X5QU3hQaItz0aOhhsbVhqHDboDbb2ZrXKH3Mj4wRqydkYc/k3I4Yx8Lp+RDaL8288ZY9oSh04fHTrBG1lYPnrXLIS0V+8x84+hxG9CNU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=M10v1VTb; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="M10v1VTb"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1785826300;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=qvuUynhwJ6vmk6JmexBa8fUitav45tNUKh63gEre9Hk=;
	b=M10v1VTbUpLnIm03ZWps8UB4jXSE8sevjRFZLT8PjpbgjLxO5CkWpoRRc7s6EDewUGs72X
	p3nuYYsyFyN9aYkxwC3/7+cBMBFY5QJdH/zjGDvdHyFhHeeosmqc7Y8qZUfWtwB+OY19fa
	NtVZOmYC1KkIDrsODSga5k7pB2ixtoc=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-177-zwZISMpYNv6NtVLFfprXbw-1; Tue,
 04 Aug 2026 02:51:25 -0400
X-MC-Unique: zwZISMpYNv6NtVLFfprXbw-1
X-Mimecast-MFC-AGG-ID: zwZISMpYNv6NtVLFfprXbw_1785826283
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 0243719560B5;
	Tue,  4 Aug 2026 06:51:23 +0000 (UTC)
Received: from blackfin.pond.sub.org (unknown [10.44.22.7])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 4EBCB180044F;
	Tue,  4 Aug 2026 06:51:22 +0000 (UTC)
Received: by blackfin.pond.sub.org (Postfix, from userid 1000)
	id E317621E6920; Tue, 04 Aug 2026 08:51:19 +0200 (CEST)
From: Markus Armbruster <armbru@redhat.com>
To: Khushit Shah <khushit.shah@nutanix.com>
Cc: "qemu-devel@nongnu.org" <qemu-devel@nongnu.org>,  "qemu-arm@nongnu.org"
 <qemu-arm@nongnu.org>,  "kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>,
  "eric.auger@redhat.com" <eric.auger@redhat.com>,  "cohuck@redhat.com"
 <cohuck@redhat.com>,  "peter.maydell@linaro.org"
 <peter.maydell@linaro.org>,  "richard.henderson@linaro.org"
 <richard.henderson@linaro.org>,  "maz@kernel.org" <maz@kernel.org>,
  "oliver.upton@linux.dev" <oliver.upton@linux.dev>,  "berrange@redhat.com"
 <berrange@redhat.com>,  "abologna@redhat.com" <abologna@redhat.com>,
  "jdenemar@redhat.com" <jdenemar@redhat.com>,  "gshan@redhat.com"
 <gshan@redhat.com>,  "skolothumtho@nvidia.com" <skolothumtho@nvidia.com>,
  "sebott@redhat.com" <sebott@redhat.com>,  "philmd@linaro.org"
 <philmd@linaro.org>,  "yangjinqian1@huawei.com" <yangjinqian1@huawei.com>,
  Shaju Abraham <shaju.abraham@nutanix.com>,  Mark Cave-Ayland
 <mark.caveayland@nutanix.com>,  Prerna Saxena <prerna.saxena@nutanix.com>
Subject: Re: [RFC PATCH v3 16/19] qmp: add query-cpu-props-info command
In-Reply-To: <FDD5760F-94E6-46F4-AC62-AB0DC98322FD@nutanix.com> (Khushit
	Shah's message of "Tue, 4 Aug 2026 06:30:22 +0000")
References: <20260716213858.609699-1-khushit.shah@nutanix.com>
	<20260716213858.609699-17-khushit.shah@nutanix.com>
	<87y0f5u78t.fsf@pond.sub.org>
	<6AA3BD42-9596-476B-9F64-AB09372821B9@nutanix.com>
	<87tspa5skn.fsf@pond.sub.org>
	<FD805FA0-9323-450C-9D79-319C0883F05E@nutanix.com>
	<FDD5760F-94E6-46F4-AC62-AB0DC98322FD@nutanix.com>
Date: Tue, 04 Aug 2026 08:51:19 +0200
Message-ID: <8733wu5qfs.fsf@pond.sub.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111
X-Mimecast-MFC-PROC-ID: gAUz6qFN7IEigj1GCT5wgWUMnGiTGt0FMTCkqKwic-U_1785826283
X-Mimecast-Originator: redhat.com
Content-Type: text/plain

Khushit Shah <khushit.shah@nutanix.com> writes:

[...]

> Stub file was missing on arm user builds. 
>
> I have fixed this on the private branch if you want to take a look.

I'm willing to pull an update to v3, assuming it's a small fix.

> I also understand if you want to wait for proper v4 with the fix.

Eventually.

> Again, sorry for this, should have checked all configs before
> sending the patch.

Mistakes happen, and then we learn from them :)

[...]

