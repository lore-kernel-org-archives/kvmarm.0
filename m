Received: from mta0.migadu.com (out-36.mta0.migadu.com [91.218.175.36])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C285447887E
	for <kvmarm@lists.linux.dev>; Fri,  4 Sep 2026 12:21:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.36
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788524489; cv=none; b=pJ4bAmfB5zVCeIfnZ5qJXdTKTNY+k/rIpltUd3HVT/pQAsLK0bXPMHYaUGQQAaoDV34yK6m1SgWN/JL2vo+x8ddcJ9FYpH/xglki+0SdfBdv0TCw/y/uvC2NV3YFRVrdHCQum7Q+ssiph5nh9NFwgU44TQMYpR0ilrqZQbe1hp0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788524489; c=relaxed/simple;
	bh=MWnONv/mcSy1ZzvbBOJBF9sO7kdoah8czNuibP8g/Js=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=CoVCDu3iEBsb4dOFJdSrorvL8mbTk3+TqacpEtIp0hTsXfCXYDISMHMHfar9znhsSKgyI1XdwAv0OGWeomx7kO2VO2LU7IHXJ7f/C1tlWWLzIOmo3bS2TdJSyP62gIXs6xolt5NPqUN1AP3izjDTzWBK+mDt0bQlFVyn4NqXVR4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=nzpy2CRs; arc=none smtp.client-ip=91.218.175.36
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="nzpy2CRs"
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=MWnONv/mcSy1ZzvbBOJBF9sO7kdoah8czNuibP8g/Js=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1788524485; v=1; x=1789129285;
 b=nzpy2CRsW44lFLcx0vqWN/MENVWD2ZVkBxTM2cXn66D2697UuZVjrH+n1olm63CojGTjRDzm
 XGKvFxDhiXIG4XzktTiqdFKH97sXoyapzyf0is1LPafX53Hyy2swNN6d11FnTOPtdywRoOUbdcq
 0vUuYLP2kZ48vCdjbooHXPlE=
X-Envelope-To: kvmarm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id 0b5a7b4feeef64f1;
	Fri, 04 Sep 2026 12:21:25 +0000
X-Mizu-Trace-ID: 0b5a7b4feeef64f1
X-Migadu-Flow: FLOW_OUT
Received: by mail-lf2-f12.google.com with SMTP id 2adb3069b0e04-5b4a0b17358so4579e87.1
        for <kvmarm@lists.linux.dev>; Fri, 04 Sep 2026 05:21:21 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBx2I/VjKpVXKqtQ3JcYECpgFyMtGj9/wd7z4eJRc/mfQrce7gG9IBqb+tW+dZJ+KOkEC4vs2Po=@lists.linux.dev
X-Gm-Message-State: AFuF++nw+hKZix0guKURAnEx9RA9u6OOLsPIbPlWZitiorCXVJaldK/K
	Xexx5M8061L9ylGocF5eB6eQ1P0KDVRwHEMjwLRHoIYZLswBW1jNdXtWem7NOZC7IydoWbtG6qg
	HQIyz5TXpdDSWdpK2TUAL653kRB7ok1u7BtAq+FtP
X-Received: by 2002:a05:6512:a348:b0:5b6:186e:682f with SMTP id
 2adb3069b0e04-5b6186e6924mr49450e87.0.1788524480459; Fri, 04 Sep 2026
 05:21:20 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260904-kvm-arm64-nvhe-pie-v1-0-29d59f245e6c@kernel.org>
 <20260904-kvm-arm64-nvhe-pie-v1-2-29d59f245e6c@kernel.org>
 <86pkyt4gvt.wl-maz@kernel.org> <eb788ad5-5bb3-4767-87b8-d35d9e3ab220@sirena.org.uk>
 <apqrky27mJmUV9UA@willie-the-truck> <05f1e2f4-173a-4226-8c98-1452c20f0a47@sirena.org.uk>
In-Reply-To: <05f1e2f4-173a-4226-8c98-1452c20f0a47@sirena.org.uk>
From: Fuad Tabba <fuad.tabba@linux.dev>
Date: Fri, 4 Sep 2026 13:20:44 +0100
X-Gmail-Original-Message-ID: <CA+EHjTx87SnshzrUF69hGTSA9JmjW9oKbx+GbKjx5W+gnWYRgg@mail.gmail.com>
X-Gm-Features: AcwNN1XeCRX4giVtMT6c-n59qRC6UqdpZVxqwiiImVnvjhpDgql12CaOGJS8YCo
Message-ID: <CA+EHjTx87SnshzrUF69hGTSA9JmjW9oKbx+GbKjx5W+gnWYRgg@mail.gmail.com>
Subject: Re: [PATCH 2/2] KVM: arm64: Enable S1PIE for nVHE and hVHE
To: Mark Brown <broonie@kernel.org>
Cc: Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>, 
	Joey Gouly <joey.gouly@arm.com>, Steffen Eiden <seiden@linux.ibm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, 
	Catalin Marinas <catalin.marinas@arm.com>, Mark Rutland <mark.rutland@arm.com>, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Fri, 4 Sept 2026 at 12:48, Mark Brown <broonie@kernel.org> wrote:
>
> On Fri, Sep 04, 2026 at 12:29:23PM +0100, Will Deacon wrote:
> > On Fri, Sep 04, 2026 at 11:33:24AM +0100, Mark Brown wrote:
>
> > > What about pKVM, my understanding was that that is very much an ongoing
> > > concern and uses the nVHE hypervisor?  My expectation was that this
> > > would only ever get used in hVHE configurations when people enable pKVM
> > > on modern hardware, actual nVHE mode was mostly just carried along with
> > > that.
>
> > pKVM uses hVHE wherever it can nowadays, so I'm fine with only supporting
> > S1PIE on hVHE and VHE configurations if that's easier to maintain. We
> > just need to make sure that the failure mode for nVHE results in the
> > feature being gracefully disabled, rather than e.g. crashing or quietly
> > doing the wrong thing.
>
> I figure that if we're supporting hVHE it will end up less complicated
> to also enable nVHE, it reduces the potential for having bad or missing
> fallback paths for features downstream of S1POE.  It's not like it's a
> huge extra bit of code and it seems likely to save hassle down the line.

For pKVM there's no fallback path to get wrong: any CPU with S1PIE has
VHE, so pKVM runs hVHE on it, and a CPU without VHE has no S1PIE to
disable. I couldn't construct the protected nVHE plus S1PIE case under
QEMU at all.

Where I think it applies is kvm-arm.mode=nvhe on S1PIE hardware. That
boots, and it's the one configuration where the nVHE side of the patch
would run.

Cheers,
/fuad
