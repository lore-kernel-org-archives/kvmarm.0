Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6759D1D5CC7
	for <kvmarm@lists.linux.dev>; Fri, 21 Mar 2025 15:38:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742571482; cv=none; b=f89LzJ3k8qjSAPNBs/N7uNfsbByt81omNU0EjWCLcrX/skeqA2PzRg6ctcSDJwwGB8+cA1xu4zGhoJU9WKPP/gUDQN269cEkCkQANMD/7pSgDRdDxwY51MOz9m1X9nIUNNlcDZeoyDcIzqfrpDEzaBR+0ESiAH6BeOZssvhxLuE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742571482; c=relaxed/simple;
	bh=Zsp9JI04JXi+Vmc7vqu6dQ+XML21a3NSKO6A2qWfieA=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=Hj1OLBxrv3kb8edSMK7YfvNqgOkvoGibY3rcx3kPTSYcyrNqHT443Md+1w0HMhzlpYRxIi26IxSmJEmRWtwXBdYTY7DHSxGud5r9ut5weWj6s4FB8j6EqGPuz2QKwjkVxZ2phdu5W/eDH8ch+UEv1LKFCNnxBJdSJZ4IIrAdBgo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=UUxRow3i; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="UUxRow3i"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1742571479;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Zsp9JI04JXi+Vmc7vqu6dQ+XML21a3NSKO6A2qWfieA=;
	b=UUxRow3iSZuFbOcLBif3hWRfzZGNVQ7uVzMaZmhf/lFTwAuKb1vEQFFhUsZVgwF9QDFTXd
	EV8hz3ZYwGtGhx7twAFLXiNzyuhzaR2pxxKo01B79XZ3ETNbK0RbNVd5xl/wYhrgJRB9pY
	JzZoeoBDVbtCdGGyWOMqdS3z82svkhY=
Received: from mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-654-b8z2Ij3BOEuwi5Dn4fMFmg-1; Fri,
 21 Mar 2025 11:37:54 -0400
X-MC-Unique: b8z2Ij3BOEuwi5Dn4fMFmg-1
X-Mimecast-MFC-AGG-ID: b8z2Ij3BOEuwi5Dn4fMFmg_1742571472
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 1827018C46E4;
	Fri, 21 Mar 2025 15:37:42 +0000 (UTC)
Received: from localhost (unknown [10.67.24.51])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 0717318B35EA;
	Fri, 21 Mar 2025 15:37:34 +0000 (UTC)
From: Cornelia Huck <cohuck@redhat.com>
To: Richard Henderson <richard.henderson@linaro.org>,
 eric.auger.pro@gmail.com, eric.auger@redhat.com, qemu-devel@nongnu.org,
 qemu-arm@nongnu.org, kvmarm@lists.linux.dev, peter.maydell@linaro.org,
 alex.bennee@linaro.org, maz@kernel.org, oliver.upton@linux.dev,
 sebott@redhat.com, shameerali.kolothum.thodi@huawei.com,
 armbru@redhat.com, berrange@redhat.com, abologna@redhat.com,
 jdenemar@redhat.com, agraf@csgraf.de
Cc: shahuang@redhat.com, mark.rutland@arm.com, philmd@linaro.org,
 pbonzini@redhat.com
Subject: Re: [PATCH v3 02/14] arm/kvm: add accessors for storing host
 features into idregs
In-Reply-To: <37fd4871-f3c5-43bc-9dd5-1c0f72dcd392@linaro.org>
Organization: "Red Hat GmbH, Sitz: Werner-von-Siemens-Ring 12, D-85630
 Grasbrunn, Handelsregister: Amtsgericht =?utf-8?Q?M=C3=BCnchen=2C?= HRB
 153243,
 =?utf-8?Q?Gesch=C3=A4ftsf=C3=BChrer=3A?= Ryan Barnhart, Charles Cachera,
 Michael O'Neill, Amy
 Ross"
References: <20250311162824.199721-1-cohuck@redhat.com>
 <20250311162824.199721-3-cohuck@redhat.com>
 <37fd4871-f3c5-43bc-9dd5-1c0f72dcd392@linaro.org>
User-Agent: Notmuch/0.38.3 (https://notmuchmail.org)
Date: Fri, 21 Mar 2025 16:37:28 +0100
Message-ID: <87sen6tmx3.fsf@redhat.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17

On Tue, Mar 11 2025, Richard Henderson <richard.henderson@linaro.org> wrote:

> On 3/11/25 09:28, Cornelia Huck wrote:
>> +/* read a sysreg value and store it in the idregs */
>> +static int get_host_cpu_reg(int fd, ARMHostCPUFeatures *ahcf, ARMIDRegisterIdx index)
>
> This still isn't used, and so must Werror.

Hm, I guess I could merge this into the first patch actually using this.

