Received: from mta1.migadu.com (out-60.mta1.migadu.com [95.215.58.60])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13F10314A60
	for <kvmarm@lists.linux.dev>; Fri,  9 Oct 2026 07:58:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.60
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791532718; cv=none; b=lnPtuYS1urwlyAFapXD+kcl5+ptDZMF599s3m0aNkUn5Ru7l8o+S+sTUGr0hncSEC9jLG2dCWysELOoMS0VxWYt8O4eSRo+O26X7X8EtVrxkTx0i68f9ZDjZByg4i2SeNrHSPs53SHzlp+pj3n1R9dtUYSFYid9Me6ADGFxQ9SE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791532718; c=relaxed/simple;
	bh=HOVfYS51lkukawzGBUztER+emMA6ntCgIQIvA0pUhsU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=CaO57JtRKgRbHwztdHyUpt/O2XkMRopWncb7gblHQ9mgJYbOuY0Ok6lUQ9E+XVjVs50r2ORmB+lf/Q/6GaqQHjvyzV4HPu762yNs1m4HRkNvLuC7sGv1MdEzEZEj4iwN7sZRgOJjLcazJ83qG2PrOt3LbK7DTDU2VlDsLtAJBKA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=rSUZcRFy; arc=none smtp.client-ip=95.215.58.60
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="rSUZcRFy"
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=HOVfYS51lkukawzGBUztER+emMA6ntCgIQIvA0pUhsU=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1791532713; v=1; x=1792137513;
 b=rSUZcRFyZL1Q6Aih7nKyp6YCoB9RVxhLUK5KWevCJeI2jlZanH+LM4X3bgOb+g1fCEvsithM
 4cdlKf9M+6vNFLBw6dIRh9I7/mqo+3eKsHBpb6z7+1gMQ4JuodbWjkCeSJeEirQPGwWpnoRjms+
 UtKIVN7dAMO8ewOLTxgclPTA=
X-Envelope-To: kvmarm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id fc9e9f0b6ca9f8ff;
	Fri, 09 Oct 2026 07:58:33 +0000
X-Mizu-Trace-ID: fc9e9f0b6ca9f8ff
X-Migadu-Flow: FLOW_OUT
Received: by mail-lf1-f43.google.com with SMTP id 2adb3069b0e04-5bcbb378fc9so6034e87.0
        for <kvmarm@lists.linux.dev>; Fri, 09 Oct 2026 00:58:33 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBxmGwQPuNjkgxFrIcJ8MIK8fnQdd98HQgTCzIJep81bKgnVQqVUMvqgv/bosZSf8oHYT8oq/dU=@lists.linux.dev
X-Gm-Message-State: AFq9FYLyYsjFk3BzOgx/vMWrxZJpO+8WDNZksxPFECYPBxiOCQcWYk3c
	mpx+ETJ3kppwAoqdL99s5JE5NgleTW5nMHIOnYeNBVHA3j/LPf+IBJcJIPrDBDp7MF3gknJ6Pl5
	esMC2tzdLCscj8dhtI+jRoIIrN4Pr+mknyieQZxIG
X-Received: by 2002:a05:6512:3b2b:b0:5b8:d830:be30 with SMTP id
 2adb3069b0e04-5bcdf978106mr42003e87.16.1791532712487; Fri, 09 Oct 2026
 00:58:32 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260831192406.1341841-1-fuad.tabba@linux.dev>
 <CA+EHjTwBXEVp_fJp+SvXqrfab2NGdnCXy6L9n=aW2yeTUUOniQ@mail.gmail.com> <asidn0tpusz-MZRp@willie-the-truck>
In-Reply-To: <asidn0tpusz-MZRp@willie-the-truck>
From: Fuad Tabba <fuad.tabba@linux.dev>
Date: Fri, 9 Oct 2026 08:57:56 +0100
X-Gmail-Original-Message-ID: <CA+EHjTyHKLZ8fJ4dEmrx1XLe9=XdhYytMFzn9pTRMaJGoa=FTg@mail.gmail.com>
X-Gm-Features: AclHuK9PqZbjeow1kT94C7mAFJI1dY9tubORoAFM4lnPAOqIjEyuT7gh9MDDRW0
Message-ID: <CA+EHjTyHKLZ8fJ4dEmrx1XLe9=XdhYytMFzn9pTRMaJGoa=FTg@mail.gmail.com>
Subject: Re: [PATCH kvmtool 0/5] Fix diagnostics and capability probes for
 protected VMs
To: Will Deacon <will@kernel.org>
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev, 
	Julien Thierry <julien.thierry.kdev@gmail.com>, Alexandru Elisei <alexandru.elisei@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Andre Przywara <andre.przywara@arm.com>, 
	Oliver Upton <oliver.upton@linux.dev>, Marc Zyngier <maz@kernel.org>
Content-Type: text/plain; charset="UTF-8"

On Fri, 9 Oct 2026 at 08:54, Will Deacon <will@kernel.org> wrote:
>
> On Fri, Oct 09, 2026 at 08:10:55AM +0100, Fuad Tabba wrote:
> > Gentle ping on this series. Marc has merged the pKVM core series into
> > kvmarm/next, including the KVM_GET_ONE_REG -EPERM that patch 1
> > handles, and all five patches have Suzuki's Reviewed-by.
>
> I usually wait for the patches to land in Linus' tree before I update
> kvmtool (although I may be fishing when that happens).

>  (although I may be fishing when that happens).

Took me a while to understand that part :D

No rush, and enjoy the fishing.

/fuad

>
> Will
>
