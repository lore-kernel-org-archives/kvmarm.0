Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [78.32.30.218])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E2A92119
	for <kvmarm@lists.linux.dev>; Sun, 25 Aug 2024 17:10:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=78.32.30.218
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724605814; cv=none; b=cc8XaVufKxn8ayjn5E5PYoVn9kPnoFL7ri+1j2GQnTAVdARrbsGsXKpzayV+jm0oM7+1AtlKrczJpkfdHtGLr3VnDbZE285ohhV6oOI8iteHOv+b+PGlCiS6zmyR8c+j2uiFeQLfJalWjTIXpMgBT2BAzviQvbANLxEeJDB/FPA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724605814; c=relaxed/simple;
	bh=jtFEa/ih3nx5VfJKrakt5NOrqfo0bR5s0nc5UcJGNZM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qL3+v3R6kZ/Zw9vhl74KAnq8v5sfWhNAqmHxazjgFymLSgYLn7ScRIps4QHF4qAMGS8/TYkaGPQSpQ6J1gwYtzpAiOwk4hZ0fP209nlxpuO0HgCBuI+b4dn0jcbCfU2T6/+QbfpEOeu0jzBm5qjaUfZEoz40ElgjE6j6deJAYQo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=armlinux.org.uk; spf=none smtp.mailfrom=armlinux.org.uk; dkim=pass (2048-bit key) header.d=armlinux.org.uk header.i=@armlinux.org.uk header.b=yUEyqmHW; arc=none smtp.client-ip=78.32.30.218
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=armlinux.org.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=armlinux.org.uk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=armlinux.org.uk header.i=@armlinux.org.uk header.b="yUEyqmHW"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
	MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
	Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
	List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=8pzwujvC7xvqp9pOTOfvQRMNZqqSXoV1ObOJZ6mWKi0=; b=yUEyqmHWs76BuKeItSQmUqT8tW
	qvoBDxcVUvlRK+h4RSyQF7MWIAFJbvtnzp/kcRrZbEjzLzL6in0j2gaEkKXPCK23wJzc0tf/YmND0
	PM/ik34KL3XS9zLdvlluhhfCGYOuBh26ziL4N6hplNIdG+goyjB4B8izxp7UoCGMGbcsqi2jzRckn
	ZAbE/OfuFscfWtY/2CQZD5Td5NOdnogUnmjdh32RfdymXD08ZklINQB05g/x0na1AAmsPTUxQctQD
	sADwpsLVYF/C8TCqSUCKsc2k4JQdQ2opCURxB26VOYgmipQTFElsyvUUAKxYNkJN1thswl+aqXMDc
	6ZH1Huqg==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:42788)
	by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.96)
	(envelope-from <linux@armlinux.org.uk>)
	id 1siGkT-0004gh-2S;
	Sun, 25 Aug 2024 18:09:53 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.96)
	(envelope-from <linux@shell.armlinux.org.uk>)
	id 1siGkO-0001ff-1e;
	Sun, 25 Aug 2024 18:09:48 +0100
Date: Sun, 25 Aug 2024 18:09:48 +0100
From: "Russell King (Oracle)" <linux@armlinux.org.uk>
To: Marc Zyngier <maz@kernel.org>
Cc: Shaoqin Huang <shahuang@redhat.com>,
	Oliver Upton <oliver.upton@linux.dev>, kvmarm@lists.linux.dev,
	Mark Brown <broonie@kernel.org>, Eric Auger <eauger@redhat.com>,
	Sebastian Ott <sebott@redhat.com>,
	Cornelia Huck <cohuck@redhat.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	James Morse <james.morse@arm.com>, kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	Paolo Bonzini <pbonzini@redhat.com>, Shuah Khan <shuah@kernel.org>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Will Deacon <will@kernel.org>, Zenghui Yu <yuzenghui@huawei.com>
Subject: Re: [PATCH v5 0/4] Allow userspace to change ID_AA64PFR1_EL1
Message-ID: <ZstlXHnSvlfnia/D@shell.armlinux.org.uk>
References: <20240723072004.1470688-1-shahuang@redhat.com>
 <86ttf8wnwz.wl-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86ttf8wnwz.wl-maz@kernel.org>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>

On Sun, Aug 25, 2024 at 05:46:36PM +0100, Marc Zyngier wrote:
> On Tue, 23 Jul 2024 08:19:59 +0100,
> Shaoqin Huang <shahuang@redhat.com> wrote:
> > 
> > Hi guys,
> > 
> > This is another try to allow userspace to change ID_AA64PFR1_EL1, and we want to
> > give userspace the ability to control the visible feature set for a VM, which
> > could be used by userspace in such a way to transparently migrate VMs.
> 
> 
> I think this looks OK now, thanks for going through the motions and
> doing the right thing.
> 
> What is missing is similar handling for 32bit ID registers, but I'm
> not sure we keen on going down that road -- machines capable of
> running those are on their way out. This can be done later anyway,
> should anyone care.

The Aarch32 ID registers need doing - we've already established that
fact. Sadly, you decided you wouldn't respond to my patch addressing
one of the Aarch32 ID registers despite me sending follow-ups to nicely
ask you about this - you seemed to go utterly silent on it.

The Aarch32 ID registers have changed value between different kernel
versions, and given that QEMU saves and restores _all_ ID registers,
changes to these ID registers cause a regression if one attempts to
migrate VMs between one kernel version and the next. It doesn't even
have to be between two physical machines. Libvirt supports managed-
saving on reboot, where it saves an image of a VM at shutdown, and
restores it at the next reboot. These changes in ID registers render
effectively data loss in VMs that have been managed-saved - the
saved state of the VM has to either be destroyed, or the host kernel
reverted back and _never_ moved forward.

As you don't seem to be keen to address this (by ignoring my emails
on the topic, and now suggesting in your response above that you're
not keen to do anything with the Aarch32 ID registers, I guess this
just means that KVM on Aarch64 is going to forever suck.

I'm sure Oliver will recall my emails on this which you've decided to
ignore... he was supportive of my efforts to address this.

-- 
*** please note that I probably will only be occasionally responsive
*** for an unknown period of time due to recent eye surgery making
*** reading quite difficult.

RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 80Mbps down 10Mbps up. Decent connectivity at last!
