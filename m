Received: from mta0.migadu.com (out-191.mta0.migadu.com [91.218.175.191])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3C61411F99
	for <kvmarm@lists.linux.dev>; Mon, 14 Sep 2026 08:41:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.191
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789375306; cv=none; b=rdD10n6yVFpuphkuh6239lEIgyrxpSgA8brtmN67RWx7W//ZbzjhJQddW5dAhq8F/tkUIVPemMqcgoNA20qaju1LH+sH3bDDuANp9vJjeZNOjLA7PTLNTaH8HGQOwj2BDsykQuqVahMzqTRMpLPkGEPqYwdATZO+cv4hplq8tbg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789375306; c=relaxed/simple;
	bh=kq8ONLBCKhnRKMHSTGyauq/vhUxAF/qU9WrtB+UmJdE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Bjj05HdKkOjGYU0o3IpN7GjyL3RwzuAAHmVZaHSzpfYyQ66103SikUBJ1vCX8se6z8eGTTKipZeoSaqTgjatMuH7N+QWzr+agnAABnrPgMlsjEoZhDoZU+uBnOrsmElDMwi0orteKtR+cvNj41BNi7mtEfWBBdNPc3jHdNA6Bcg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=Tk5lztRr; arc=none smtp.client-ip=91.218.175.191
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="Tk5lztRr"
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=kq8ONLBCKhnRKMHSTGyauq/vhUxAF/qU9WrtB+UmJdE=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789375288; v=1; x=1789980088;
 b=Tk5lztRrBiiVPvmAsWOjr05rWJhRp+mnqdgWNW1dr3oHx/2JujgiYYANZQH5rvyBSyYx8nxQ
 1zVj91+4TOW6WJDia9YtgfkTHpNXgmfsZcTJ5UZW3k1JTSl0aGHqc4pVg53WDiw1Ur3jKewUZDu
 QN2c0P/oeEHiOziT+U56dSoY=
X-Envelope-To: kvmarm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id 577547bd36fe3481;
	Mon, 14 Sep 2026 08:41:28 +0000
X-Mizu-Trace-ID: 577547bd36fe3481
X-Migadu-Flow: FLOW_OUT
Received: by mail-lf2-f12.google.com with SMTP id 2adb3069b0e04-5b4a0b17359so5833e87.0
        for <kvmarm@lists.linux.dev>; Mon, 14 Sep 2026 01:41:26 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBwYdPtcRKwbASndYLQZDZBFiNfCMFWc6zHVKivU8fhgFrsCyIY/oRWtDc/kAv3WAlzi8oJucEQ=@lists.linux.dev
X-Gm-Message-State: AFuF++mr8vD2+vDrxQLeQVHMzUpkubcT/0Ggl4s5ehsRnZYwFkdcMx2R
	5zCxL+Iq+oh1+7vzUJOPOVkyNJdNelXVlGSDO62DdOP9P5KFObeDEn0Vb+jVimMauiudbqMWPz2
	Y9iAdZofU5KUJRuKhLcQCr7VESkqHnLuprNxVv//d
X-Received: by 2002:ac2:5681:0:b0:5ae:b1b3:145a with SMTP id
 2adb3069b0e04-5b8ae4c4829mr34163e87.6.1789375286167; Mon, 14 Sep 2026
 01:41:26 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260914075839.4019904-1-vdonnefort@google.com> <864ifs6xn4.wl-maz@kernel.org>
In-Reply-To: <864ifs6xn4.wl-maz@kernel.org>
From: Fuad Tabba <fuad.tabba@linux.dev>
Date: Mon, 14 Sep 2026 09:40:49 +0100
X-Gmail-Original-Message-ID: <CA+EHjTzo0CkWn71u5oUu+7N5rJPSqQet=ZOX0NiDeCCS5_WmKg@mail.gmail.com>
X-Gm-Features: AcwNN1WueFHNfiNwCU61DH-wtI4voCuC5YQoJp8Lcgui_VK5ffKNHoGcfiMKeZA
Message-ID: <CA+EHjTzo0CkWn71u5oUu+7N5rJPSqQet=ZOX0NiDeCCS5_WmKg@mail.gmail.com>
Subject: Re: [PATCH v2] KVM: arm64: Fix protected VM fault on system with
 pages larger than 4K
To: Marc Zyngier <maz@kernel.org>
Cc: Vincent Donnefort <vdonnefort@google.com>, oupton@kernel.org, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org, joey.gouly@arm.com, 
	seiden@linux.ibm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, 
	catalin.marinas@arm.com, will@kernel.org, kernel-team@android.com, 
	qperret@google.com
Content-Type: text/plain; charset="UTF-8"

On Mon, 14 Sept 2026 at 09:32, Marc Zyngier <maz@kernel.org> wrote:
...

> It is a bit annoying that neither gmem nor pkvm are using
> kvm_s2_fault_vma_info, which has the ability to reports all the
> important stuff, as it would avoid this sort of bugs.

That's on my list of things to tidy up, fwiw.

/fuad

>
> Thanks,
>
>         M.
>
> --
> Without deviation from the norm, progress is not possible.
