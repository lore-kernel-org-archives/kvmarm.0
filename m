Received: from mail-lf1-f42.google.com (mail-lf1-f42.google.com [209.85.167.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9CEF6FB8
	for <kvmarm@lists.linux.dev>; Tue,  6 Feb 2024 01:32:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707183153; cv=none; b=O1UJsudVllNPWvF7rssTIZnqQduxzHOgRZIgzjefPZ1GglVsuZ/lNI4llaflqjkEJhr+AWNxc+C+s0Y1LW1eNXkeJPcAslYc2kFjRU5gFQx/EHx9ytok0X1Y5mnvFK1GBNf0eVfts20JpQr8+6SDHqv1znGtqHr+mMgRUf5iy64=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707183153; c=relaxed/simple;
	bh=rVAbmPsAGtvO+Qd+Hb1hgCb6dIT6VZnul4EDRYLBi3U=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=YSH+uHPlaCsHrPrkpk8CAKxkyYqzya8STAck5LxgjoTStchlTFCMIFpW19txQ4jh6IvefhYEPaL4MqpHMeEvyy7J7Did464+53t+lXAeglN6e7yiekLux9tVRcu+ScNiqiFz3Mrp7feCcxSENUUdXkktwBnRJaFnxPDw8/uQB74=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=SqbDSI6C; arc=none smtp.client-ip=209.85.167.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="SqbDSI6C"
Received: by mail-lf1-f42.google.com with SMTP id 2adb3069b0e04-5113303e664so5447432e87.0
        for <kvmarm@lists.linux.dev>; Mon, 05 Feb 2024 17:32:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1707183150; x=1707787950; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=QApOFbEPm/JI1t7SVH7QEk9OREXHhc6+siBSRqc1pgw=;
        b=SqbDSI6C3OmgelQ9IujNiEsMBZqokaLBiJ1uIr0+xwc9S1TFaQVrSKFfem5QGSZTlL
         AU3vHFiZ4SqzaByQNvWuqswPyvKY1vHDcNFUTJ8tUIibFvUfnmjoZUgn1vORKTmlCsp7
         ipmtKF2tjF0OhpmtOeyMIwHW9yt/9LCUW4k7ucz94cXrcHm+kFpy6Zb5bRENyGs82joG
         yMblfq9UMF1fvLFrwJd0rl4g4uWFdI7Ck81A5KBca+up0bSOeKJ2Tehn8ppn2Horw1RV
         ktmAg6y+MPzdNACA/1HH/OdmirmeQ8ketWzr0J7GJHetsPZnIX8mWx78hyP8s6MmmGOt
         cBTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707183150; x=1707787950;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=QApOFbEPm/JI1t7SVH7QEk9OREXHhc6+siBSRqc1pgw=;
        b=LIIO89cQysTC94uqlrIriPHKO07IJZ82K1LrhRvBxS3sBf96I/8ZirwbaTsCOjsfcm
         1MQ5yxlTLt0KO18PyPPT7uiem+E85m4pLz8JBsrPqGUKv+/VQvjXTfFycjI+bWDkDF5b
         B9pfAUWdiMn7VOgQGQoe8FzD0lps881f6DMnshcD/s2ZsKPfC1gpwUNtuPZUOubPtUb7
         lRVpZqUR2O+vvYE6Jt6BqTbKp4iqmtAo1XWtHpG92r8bvacXDn6Ps1bz/Izh1szew79g
         gOy6iA1fmCA1ybGQ4m+B6qH67DAtux5WKQlRDZE0BnKbmAp6LSGD4TRXd6KANZ0CdgS7
         fMtQ==
X-Gm-Message-State: AOJu0YxW3gl+s6F/OQhj/CGf1xjA19gQgdTdUKsHOBawiFcf6xNduCeI
	qrlQ/B76zm7JEhJTpaRUenHN2RdzpU4CY/vjsG1JGXdOw7P+NLJuzVBPK8i+86OA1WjrN/SZoy/
	/mOvmRXLnpjtmfHaAp2WlPhEyAqk=
X-Google-Smtp-Source: AGHT+IHUMaYOGTgK+RnvIZj4DE1FVEUcXcafoRoI1YyaPAB0kLsdo4GRcmUByonmfL4zI4Q8fbXBT9T2+pTV4cvG+FU=
X-Received: by 2002:ac2:47ee:0:b0:511:3058:735c with SMTP id
 b14-20020ac247ee000000b005113058735cmr548346lfp.23.1707183149595; Mon, 05 Feb
 2024 17:32:29 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <cover.1705916069.git.haibo1.xu@intel.com> <CAJve8onDbX44Ph6a-FdO2+p7QOQLah-7OyF+yUc06wud+SvmQQ@mail.gmail.com>
 <86zfwe6frn.wl-maz@kernel.org>
In-Reply-To: <86zfwe6frn.wl-maz@kernel.org>
From: Haibo Xu <xiaobo55x@gmail.com>
Date: Tue, 6 Feb 2024 09:32:17 +0800
Message-ID: <CAJve8okvg=UTWgmE=TpJT=nQJB3i6R_Tn_0AS1MtsD0mP8i3JQ@mail.gmail.com>
Subject: Re: [PATCH v5 00/12] RISCV: Add kvm Sstc timer selftests
To: Marc Zyngier <maz@kernel.org>
Cc: Haibo Xu <haibo1.xu@intel.com>, ajones@ventanamicro.com, 
	Paul Walmsley <paul.walmsley@sifive.com>, Palmer Dabbelt <palmer@dabbelt.com>, 
	Albert Ou <aou@eecs.berkeley.edu>, Paolo Bonzini <pbonzini@redhat.com>, 
	Shuah Khan <shuah@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	James Morse <james.morse@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Anup Patel <anup@brainfault.org>, 
	Atish Patra <atishp@atishpatra.org>, Guo Ren <guoren@kernel.org>, 
	Conor Dooley <conor.dooley@microchip.com>, Mayuresh Chitale <mchitale@ventanamicro.com>, 
	wchen <waylingii@gmail.com>, Greentime Hu <greentime.hu@sifive.com>, 
	Jisheng Zhang <jszhang@kernel.org>, Samuel Holland <samuel@sholland.org>, 
	Minda Chen <minda.chen@starfivetech.com>, Sean Christopherson <seanjc@google.com>, 
	Peter Xu <peterx@redhat.com>, Like Xu <likexu@tencent.com>, 
	Vipin Sharma <vipinsh@google.com>, Thomas Huth <thuth@redhat.com>, 
	Aaron Lewis <aaronlewis@google.com>, 
	Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>, linux-kernel@vger.kernel.org, 
	linux-riscv@lists.infradead.org, kvm@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, kvm-riscv@lists.infradead.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Feb 6, 2024 at 12:24=E2=80=AFAM Marc Zyngier <maz@kernel.org> wrote=
:
>
> On Mon, 05 Feb 2024 13:10:26 +0000,
> Haibo Xu <xiaobo55x@gmail.com> wrote:
> >
> > Hi Marc,
> >
> > Could you help review the first 3 patches in this series?
>
> For these 3 patches:
>
> Reviewed-by: Marc Zyngier <maz@kernel.org>
>

Thanks for the review!

> Thanks,
>
>         M.
>
> --
> Without deviation from the norm, progress is not possible.
