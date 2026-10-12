Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32E8349BD82
	for <kvmarm@lists.linux.dev>; Mon, 12 Oct 2026 15:29:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791818991; cv=none; b=Dm/Jb5oi8fHQOG5qs+IkfhnghJODvet40w2+8+rgmx2//OdLEX/nAaPWyVVr3pLAMmi85ZHGy/hrcyY1XygOGmDnt3WqLEiEkKCYX6qEkkuTzSMJV3GvziLvXlVNKpsRYWn68+LGJ9I7yuKb44kUWamsYnuP5x2TBWK30p9/Adw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791818991; c=relaxed/simple;
	bh=S/6wBu1Qy0PjFWFsGd4NPUc2/G0ASzabS+h4tG5IOy8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ZNtrMYVOsygzY03kfMHykQTr3rVVdgfRYBx1nVC6UCZeerzI1+kU1X3EN0kisE6OVRtTNbvT2BvZk6nujbCf8txXcnjPxK+Vb8nufUpyPRkrEPyQjfp5u5TpgtSdlDtln2W7+OxI0qveXnqZOtOMqyIbicuYsZKpcgRKarMlFRY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=rz8zh8MO; arc=none smtp.client-ip=209.85.128.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="rz8zh8MO"
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-49d05d51553so13152525e9.2
        for <kvmarm@lists.linux.dev>; Mon, 12 Oct 2026 08:29:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791818988; x=1792423788; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=dHaZjZ/K9HkcWHP0xoN3hdI7zGw/VH12N/DXI78bY9w=;
        b=rz8zh8MOmCcuL8FhVroLquqHtkxlXzTUKX47L81zn0TICo+BMjuC7yOa19k3SbF82G
         HwvmG4NIDqDundZMa1hcZFm/cSRfqq1Y4N+qXEKO5kPK9lNssCciqkbAFIdGsZKpYM6i
         4NvYjEU2lgIg2uO8LkT/as0Eke0905xO/uaR9wGe1g4mLufPIRSXGn4dVXwiWk461273
         oK++G5XtOn/5RESFbOOOC5D92QgH3EPfJqzfDU3mubHXoTrUhSzAd+It9G+jg7qbKQY7
         0bZNbLuKC52c5KILwskupTy9blZKrgXDeatFTPNPs+v0kfGJyxoZ+pWLfCLALMgRqx5z
         Ahsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791818988; x=1792423788;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=dHaZjZ/K9HkcWHP0xoN3hdI7zGw/VH12N/DXI78bY9w=;
        b=XOuiq714wE0PRzD2xwOKcoNv4rLfPJcMOYXdossnOXa9ACUCrcp1i8sV2EvzlULpW8
         dmXFFXwsuMFIZGJHXZ4yVVfr6OZ+zYhmNpQ6JYvAgPiXtru8eHm8rm+bwFBxLidTFg25
         0DWRHveAqVgvcopc0DP1AMnJrmDEH4UCcaEFSnJPhfMuO2PeT0bWJ7VMjRf3bA85vj5U
         2PrhJNwg/ADRyKrAzT5GUONIpX+xHeQWLIHm3TYJ1+XuE7xmG+u6KAmUbmzEPvlpdskp
         PXJuPW8/drwegjLw1eWRWMhSVf2yNB2lY/aactkpkChwA/s2rvVg1IkPvwygU8km/BjZ
         V8LQ==
X-Forwarded-Encrypted: i=1; AKwUvBycvWFBNKKmlkYtEpMdcusmXACs/bA+FSogj8mKNil/Aoe88aCX/WRCLXlBubT1lcaptJ5fNgs=@lists.linux.dev
X-Gm-Message-State: AFq9FYKi8w/n6/ly242s1/nHrlCbggd1yAB+VG4wkiqWCmb/FeOuHeVp
	Bm09oiBsmMsJI0rmnOvksnQhYK/1RohBOJc5uO6a/9PrXSKLb5vF4DAo
X-Gm-Gg: AYBFou3VtpMOuM9fNUZc0GFsLqtujwig6XgN0CPleQpb7lr8Nl5LdG/ob9ZlAmWgqeE
	gz499Gc3jW6R7roc/nBm7sJoCJqLgv2L+PaEIP7Wp95a7GHcDxOI1CvSYHotXGSyTvTCE/NgvOR
	UKAy5hVtPH3UnkcBxUTwjeverI8qKmFIh6SUIrI2W3u1+kcM5ctqruj6B1Wd7CP27aCs3DX5VRO
	xTlueeEroXKy1x6PglZvS7blEgosb4qFmP5zDqdbacFTg3ymPDskxYg/NnREMQ9tPerD0CF1r5y
	W9CZTXm46LRMlY8kghKfAsjEUckis0tRrOeF6Y4xeTbyRNOacG1uwnDhXGV5s1hLAkr6Bpfiwsk
	3YVuCxilA2hlq4qROllWvoRITY9EY4Z4XJ+1UAT1qRpj62vQcZE4zhozdWGzIqB1iZF2j9l8eB2
	WyfzyId83HxRacYFZYIr0TL5iud8YKs6ocrilIZpC59H9EpkrfCNX5H4lddMfNPs2aiogo9ZBIg
	whnDOMyvB3+hM3R2jFiDHH3HOyMXKTE4JERWe6Vzx7WMGOiMoJ2PoksBDfb+UGYDCQ5ONl0nAnV
	LmAN+yY3AxWS1ukq5oURoJusgHA++l92b9g=
X-Received: by 2002:a05:600c:8105:b0:4a1:714d:eed with SMTP id 5b1f17b1804b1-4a18e4841c1mr177576875e9.14.1791818988354;
        Mon, 12 Oct 2026 08:29:48 -0700 (PDT)
Received: from dev-dsk-fgriffo-1c-93421965.eu-west-1.amazon.com (54-240-197-234.amazon.com. [54.240.197.234])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4a190344032sm299058135e9.15.2026.10.12.08.29.46
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 12 Oct 2026 08:29:47 -0700 (PDT)
From: Fred Griffoul <griffoul@gmail.com>
To: Jason Gunthorpe <jgg@ziepe.ca>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>,
	Sean Christopherson <seanjc@google.com>,
	Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>,
	Sumit Semwal <sumit.semwal@linaro.org>,
	Kevin Tian <kevin.tian@intel.com>,
	David Woodhouse <dwmw2@infradead.org>,
	Ackerley Tng <ackerleytng@google.com>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Thomas Gleixner <tglx@kernel.org>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	"H . Peter Anvin" <hpa@zytor.com>,
	Joerg Roedel <joro@8bytes.org>,
	Robin Murphy <robin.murphy@arm.com>,
	Alex Williamson <alex@shazbot.org>,
	Shuah Khan <shuah@kernel.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org,
	kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	iommu@lists.linux.dev,
	linux-media@vger.kernel.org,
	dri-devel@lists.freedesktop.org,
	linaro-mm-sig@lists.linaro.org,
	linux-kselftest@vger.kernel.org,
	linux-trace-kernel@vger.kernel.org,
	x86@kernel.org
Subject: Re: [RFC PATCH 2/6] dma-buf: Add get_phys() to describe a physical run
Date: Mon, 12 Oct 2026 15:29:46 +0000
Message-ID: <20261012152946.63489-1-griffoul@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261012144616.GF14213@ziepe.ca>
References: <a04f17cc-f59a-4240-81c8-29776eee3a2e@amd.com> <20261005132046.30025-1-griffoul@gmail.com> <f0077cec-10fe-400a-b229-f7434e297364@amd.com> <20261012144616.GF14213@ziepe.ca>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On Mon, Oct 12, 2026 at 11:46:16AM -0300, Jason Gunthorpe wrote:
> I don't want to keep expanding this hack in iommufd. If dmabuf is to
> be used then dmabuf needs to provide a pluggable way to fill the
> iommu_domain that many exporters can plug into. I don't want to
> hardwire every exporter into iommufd, that makes no sense.
>
> The existing arrangement is to motivate solving this problem
> generically, not something to be expanded on.

Agreed. The iommufd registry I mentioned above was never posted, and I
have dropped it.

The series I posted since takes another route, without dma-buf:

  https://lore.kernel.org/all/20261006183235.16576-1-griffoul@gmail.com/

It adds a small interface in mm for drivers that own memory. Such a
driver hands out files, and for each page of a file it tells the caller
which frame backs it. iommufd maps the file with IOMMU_IOAS_MAP_FILE and
builds the iommu_domain itself, and the driver revokes a range when it
changes. So iommufd never knows which driver it is talking to, and there
is no symbol_get(). guest_memfd uses the same files for the guest. The
iommufd part is patch 5:

  https://lore.kernel.org/all/20261006183235.16576-6-griffoul@gmail.com/

The iommufd part is mainly there to show the interface, and it needs
more work. Its revoke unmaps and then remaps, so a device can hit a
hole. I would rebuild it on the REPLACE operation David discussed with
you at LPC, with the scratch page as a quirk on the IOAS.

Is this the kind of generic interface you had in mind, or would you
rather have it hang off dma-buf?

Thanks,
Fred
