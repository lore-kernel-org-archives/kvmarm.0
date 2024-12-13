Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBBEB1E32DC
	for <kvmarm@lists.linux.dev>; Fri, 13 Dec 2024 16:45:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734108361; cv=none; b=BiyLuK+3cW+JE8TDe5pyB2rPg6bQaKJlgMWJavdWUVfLY+pH5RPsmkvjs7TEn/1t0Dkb3yKlV5Qvh3tp5S6qsrknMa3UhgvotMaisXpN9+lhxrmtMfCyHz8IgIoRlgJaD27cwgwZ/670zHaOU4wQObyaeTKScS/rmDg0HMxVmFI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734108361; c=relaxed/simple;
	bh=5Y6rrymz9Cpt4ZZ+qupeuk6u6jV+dzKzkCZVGmBPnRk=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=s7mL+HCVOy0b+C7NDB4JpV7Eg8Chu5yWn1xX1tIk5NQtqG2BkoS0/zBON4Imbul2o38+yc9hD+PpnUSXqMi5UG08CpPFWntJTDvpEHf5cKndY/oItD5YPMetCNGDyM39Oie/xIN91FwBiAZDan11/SWiOtDL78Hh2DJsHm29ShI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ZrNf6Bpd; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ZrNf6Bpd"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1734108358;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=5Y6rrymz9Cpt4ZZ+qupeuk6u6jV+dzKzkCZVGmBPnRk=;
	b=ZrNf6BpdIgWY1HNAHgFnL6GOiXerH/+XtUnDJSofLL86e4v0OjQlFEt5RsN8YMz3A4Zs+x
	O8DU2wikpsFUEzE3rNakY+a+X3B1cXVNWJet0jnLuJ2WUDGrjFjFkW615iVozpr71l05qw
	MnvWcPaezvWIUNl+EytiJLho6oxBXy0=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-355-J4qSIaSGN3q2bEke_oHsxw-1; Fri, 13 Dec 2024 11:45:55 -0500
X-MC-Unique: J4qSIaSGN3q2bEke_oHsxw-1
X-Mimecast-MFC-AGG-ID: J4qSIaSGN3q2bEke_oHsxw
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-3862b364578so1580604f8f.1
        for <kvmarm@lists.linux.dev>; Fri, 13 Dec 2024 08:45:55 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734108354; x=1734713154;
        h=mime-version:references:message-id:in-reply-to:subject:cc:to:from
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=5Y6rrymz9Cpt4ZZ+qupeuk6u6jV+dzKzkCZVGmBPnRk=;
        b=kfqEMkal3fpjCXtYFWkHVRAOWJ+gtHVXFSEB3MAwAgQXHyxiiJrHTofO8XyPP3GaSv
         GG8pcWmPOEfnRH/DbTvZUYMnncq6gYYljQ+IINW+sfRWi5NPCHTMS/Xa8tZ2u2Z+NaEq
         B5QFwNPZv5XFdJ5Ao9iS5xGNhQbrWlCE1xrFFMZgRX3WnBgTjgympBclANcJDVLNP5CK
         KxiEgvx5otTbRDkV+p/zMD5kafyHiFT91Z/KYTzMy3jJVsYYbUNxwGBuxn84HQqbFwst
         753sHwoJiJSeFHIpY8TiSjU0JWZxB4zfIxmjDLCRY9fJV/+pl0fJ57830q17WN0YuTmn
         WK1w==
X-Gm-Message-State: AOJu0YztkDnJnoBWawF1v/xSVfSNNxx/IHOw5UT6TTr2GoIYy5dsMK5w
	QEDxDW3xvhzWUr1D9AjsUSzrkczAv3iAkFV9hqoDLHXepcUq5huDS+lGek2xq8Kvs4JsV3FCEtT
	592QIAOke7mt8cWXKV/njjRwS+IYyIbg1/2FjpVfTjEKztIi841iGWA==
X-Gm-Gg: ASbGnctp8lCY+XchBwE10QW+NNAAnqzYKz3dV1XpIQ0ysaVDKlFtgGh+qKByp4MkE/4
	6er1aEkU0kuwycuoDGdqGVwWe3etRePjcvbM5CYehZuRWUo+4cYRG9HjL1SkmZ/gYU0AH7ylyBz
	uxGz9BXR/KJvFQgtTkgjIFMA9IduvU4uWl2MnJqBOQpS1MIQ/Pl7YQgsQyX0tWSO8U1K5+FOpXe
	P25510jlKUYbMZFGrXd8aRrngChvbtts54XJyuycWtbBcuFty8BSsdEE5XL2pH1pRLLfPH7Pt6i
	S+jWO33F78E3YGRyqhIr3zvypVW6
X-Received: by 2002:a05:6000:4b0c:b0:385:fa30:4f87 with SMTP id ffacd0b85a97d-388c35bc364mr3160585f8f.0.1734108354143;
        Fri, 13 Dec 2024 08:45:54 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGkku6qh3dDcEB3F275XNRTYMIzS0gJCxijFbXDhWoWzHJOCYC9lv4K9hqsbt3d3HId86LVhQ==
X-Received: by 2002:a05:6000:4b0c:b0:385:fa30:4f87 with SMTP id ffacd0b85a97d-388c35bc364mr3160557f8f.0.1734108353794;
        Fri, 13 Dec 2024 08:45:53 -0800 (PST)
Received: from rh (p200300f6af0bca008282df582fad0b68.dip0.t-ipconnect.de. [2003:f6:af0b:ca00:8282:df58:2fad:b68])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3878248e600sm7717041f8f.7.2024.12.13.08.45.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Dec 2024 08:45:53 -0800 (PST)
Date: Fri, 13 Dec 2024 17:45:52 +0100 (CET)
From: Sebastian Ott <sebott@redhat.com>
To: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
cc: kvmarm@lists.linux.dev, maz@kernel.org, oliver.upton@linux.dev, 
    catalin.marinas@arm.com, will@kernel.org, mark.rutland@arm.com, 
    cohuck@redhat.com, eric.auger@redhat.com, yuzenghui@huawei.com, 
    wangzhou1@hisilicon.com, jiangkunkun@huawei.com, 
    jonathan.cameron@huawei.com, anthony.jebson@huawei.com, 
    linux-arm-kernel@lists.infradead.org, linuxarm@huawei.com
Subject: Re: [PATCH v3 3/3] arm64: paravirt: Enable errata based on implementation
 CPUs
In-Reply-To: <20241209115311.40496-4-shameerali.kolothum.thodi@huawei.com>
Message-ID: <09f590eb-fb3e-6a5c-512a-440613d79c5b@redhat.com>
References: <20241209115311.40496-1-shameerali.kolothum.thodi@huawei.com> <20241209115311.40496-4-shameerali.kolothum.thodi@huawei.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: EFL1zzGTYtUY5RY4IZ4ouXWduQQZKQbRIqkx0oQ9YGc_1734108354
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=US-ASCII; format=flowed

On Mon, 9 Dec 2024, Shameer Kolothum wrote:

> Retrieve any migration target implementation CPUs using the hypercall
> and enable associated errata.
>
> Signed-off-by: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
> ---
> Note:
>
> One thing I am not sure here is how to handle the hypercall error.
> Do we need to fail the Guest boot or just carry on without any
> target implementation CPU support? At the moment it just carries on.
>

I vote for keeping the current behavior. This way the vmm could just
decide to never migrate this vm and if the vmm figures that the issue
is so severe that the vm should not continue it has the power to do so.

Reviewed-by: Sebastian Ott <sebott@redhat.com>

