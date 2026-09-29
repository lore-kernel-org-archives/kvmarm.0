Received: from mail-wm2-f13.google.com (mail-wm2-f13.google.com [74.125.225.141])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8033F468C3F
	for <kvmarm@lists.linux.dev>; Tue, 29 Sep 2026 15:59:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.225.141
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790697563; cv=none; b=ONoBhFUEN6Naxoukz91WBgdaIGRv4W1z/bsmMb8QN7LeHeEtahsKeF8fW/G8Bo2i4zTblkjhph9Ql6EETDNIjVu0PN0mXxJf52FXjTlIFPZirwEvcA6b6s2XjvjmTT6g/i9lidESD/xXuKVpmIvpK/ogbKfFhiDMBeqAu16LGUo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790697563; c=relaxed/simple;
	bh=bwnWYK80nFfKr3iwUcfFe3FiEOIbobSQBQGXAMlfsws=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=C3e35uke09yOpWxubCtyGZJtmr1Wn5ogXnvohmNuxKkZxD3TiUvPJlnvJtozFEshDWKhKPBI5uYihbNKc831wYZbEplsNzgT4uZ0cEloVZVWDg754BKj9slk5PNUijOapSQvtDCaJjFUPFYlBehdvZsU4H47HBRL0OCaRFA8MeU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net; spf=pass smtp.mailfrom=gourry.net; dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b=JQtaqqS8; arc=none smtp.client-ip=74.125.225.141
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gourry.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b="JQtaqqS8"
Received: by mail-wm2-f13.google.com with SMTP id 5b1f17b1804b1-49e8185e037so24869425e9.3
        for <kvmarm@lists.linux.dev>; Tue, 29 Sep 2026 08:59:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1790697560; x=1791302360; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=3j1GsvDFG4oGBkWvUsNYUZ4jWPGCGdM9fhJMq32ExyQ=;
        b=JQtaqqS8rkVniOwKik058A0XpylMwQASYr0mnUc2x+Lakfouv0nRy4UUHxjXqPc7DF
         qgqbH42cKoLteS5EgJZ2I0hi9vUwyuOp+f0kZ27fIDAgzyqIowePBCQZ2PhmnNl6Abmj
         0gzKBrUqM3MH2d3T5eGA9zP0hjk1+LBrJygWFAopM8+eLP3a3OJQlhp+IVJPCfQl5vbl
         +Ih+aMu+GC4ifHcT5l98OsP1OBRFgSvMaimBYdkl51ZvOZhO3T+WJ0LlhJI64CgmOIXU
         lOe2Edc17vi7+hA663wzI5PYXujYtDxzrE+pbuRvZ7oItAky27SsSyCqdRSll3kSXsoX
         7pJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790697560; x=1791302360;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=3j1GsvDFG4oGBkWvUsNYUZ4jWPGCGdM9fhJMq32ExyQ=;
        b=JVlRHSUvqkRp7x5arIJDKTonNWKJ5W8I2w7GUGFDaVgEc1Z5fxgnT38kK+REUc/B+2
         6DE23LIs/qcF//VwVUI1yAA5JmqISPgBlOCY9lTJ36yQMmS3CDrAo8I4f0SlEfZui4b8
         Z7EYfWKhWg5SRfRTaqjN1EzX33Hl6Tr4ISuZnEgS5RozblzRqT3uyPsYRYvwjuDLsjy1
         MT+KvmYhXJNJpWCuNjbZXf4zELguleSL6Oz6qOXHLEre7TWmOLPm+jFNSX1PVfI4lv/d
         BnUDpfCo997Y1/9a9ax9wpFMrz0LDYUTpDdcYeDSIXTiblIHbrm3s957B3gIdh9GTjhX
         dS4A==
X-Forwarded-Encrypted: i=1; AKwUvBwA2UgrFygJ7lTUKz3UYNr06Oxwnz4Qp/lq5H/Rwy6wy9sllLHn2XfZxBb/nUQnMJHd++anQs8=@lists.linux.dev
X-Gm-Message-State: AFuF++nUROnN0WbIDhE8GSTxt/vw2VEZmGhfO4yYZJOcC50Ta/1jECEh
	HWpUqLYZa1mMUf3X8516sGcjzlLP8gtZkf4pdAkgxfr2iSJgYflvoH0moqhxoI99Fgc=
X-Gm-Gg: AYBFou3Qs+aKLvEfyte0Fs79lmTCjKoQl7l+QlsO255UkJT5XUfpLbpSbsNvL9VkuNz
	8MpERdLq4RMCMLJSy30dzTxlAxdLaRb9BVvSRCe9Ph6NR3yZbJlp/nAZGnj4gbO3w0nmLlgiQXY
	ROQDWH83e6qGLFMvnioQ89tckBCZB6yjS03tC4qvvbJn0orFXxYsgWrtZSiSweITxbgr7FitbZw
	QMTP0FNpdVJSHZWoEc9CYOOs5lhV3N4y3su8X/V3Hrht502E6BYjELOhw15wtKsbyxHJ5sLv0y1
	K/LSzp071U9DgNkiMCIEeb4h3JHnIicNNScpgei2tvxLfXuohXIFMOdkuC74n6rJD2NcoYGELJr
	6Ich/Kpo1RYACqmhLnpSNVM95WVDVgbBPeANg67ipBh7NnKYjgVNNJ8WXcmbr0cQVNfZeWF16c1
	zhkIZjjIOm8LyJ+M1tDY4ZKZXCGtXW7tmxFMu0DdFrJrNBlNCxHGFwfrqxteL5QJek9w==
X-Received: by 2002:a05:600c:46d4:b0:49f:ec98:f030 with SMTP id 5b1f17b1804b1-49ff06f839dmr227620145e9.33.1790697559827;
        Tue, 29 Sep 2026 08:59:19 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F ([2620:10d:c092:500::5:5c0])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4a013c6f295sm7062155e9.0.2026.09.29.08.59.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 29 Sep 2026 08:59:19 -0700 (PDT)
Date: Tue, 29 Sep 2026 11:59:17 -0400
From: Gregory Price <gourry@gourry.net>
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, linux-usb@vger.kernel.org, 
	linux-rdma@vger.kernel.org, selinux@vger.kernel.org, linux-sound@vger.kernel.org, 
	bpf@vger.kernel.org, linux-scsi@vger.kernel.org, linux-fbdev@vger.kernel.org, 
	dri-devel@lists.freedesktop.org, linux-trace-kernel@vger.kernel.org, 
	linux-perf-users@vger.kernel.org, linux-arch@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, linuxppc-dev@lists.ozlabs.org, 
	kvm@vger.kernel.org, kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org, 
	linux-s390@vger.kernel.org, sparclinux@vger.kernel.org, fuse-devel@lists.linux.dev
Subject: Re: [PATCH v3 07/40] mm/vma: tidy up map kernel pages enum values
Message-ID: <arvgNTUgcO0nPh-V@gourry-fedora-PF4VCD3F>
References: <20260917-b4-mmap-prepare-vma-flag-sanify-v3-0-4583d8a23bca@kernel.org>
 <20260917-b4-mmap-prepare-vma-flag-sanify-v3-7-4583d8a23bca@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260917-b4-mmap-prepare-vma-flag-sanify-v3-7-4583d8a23bca@kernel.org>

On Thu, Sep 17, 2026 at 05:22:16PM +0100, Lorenzo Stoakes (ARM) wrote:
> MMAP_MAP_KERNEL_PAGES is a mouthful, discard the MAP_ as that's implied by
> MMAP.
> 
> Also while we're here delete useless comments for mmap actions whose names
> clearly indicate what they are for.
> 
> Also update the userland VMA tests to reflect this change.
> 
> No functional change intended.
> 
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

Reviewed-by: Gregory Price (Meta) <gourry@gourry.net>
