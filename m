Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B85408470
	for <kvmarm@lists.linux.dev>; Mon, 14 Nov 2022 19:30:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 626EAC43470;
	Mon, 14 Nov 2022 19:30:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1668454235;
	bh=llpXHAF5OWOiK2xL3RLSoCIqLyphKu1AInLE8Ka6w2I=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Rhq6nrc3C4VKkHptcd+G0RQtCpi59Klo/ayDVDPn579Q60QJ+4QqrBtebMdndZaWM
	 9Sp0UjXcF+SHwpZbqdQFP3aqLzi5QR5SV+fR0BXOuZ5CFAoK/x0x1NWguBnyVYUD9M
	 CFs4Q5JJ8p0tQeJjSn3U9MeuHhjh5ezdmGuR/Rho7lVMGos6NKefqFVAKkjjw7Rw2h
	 jGpoCpHk25l0OGpDmoOiv6lKU9yvB75jS74r4jqVUDQ7ee9Xsjhy3VsOYLhvbw58j6
	 PxbEEMYvpD43VZYlDUNH+xP8yBFUJB0YIiy60JK4pg8MqYV+7bqf6ev8MydM+RzcKp
	 nqXu+Im45Tefw==
Date: Mon, 14 Nov 2022 19:30:28 +0000
From: Will Deacon <will@kernel.org>
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, Vincent Donnefort <vdonnefort@google.com>,
	James Morse <james.morse@arm.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	kernel-team@android.com, Quentin Perret <qperret@google.com>,
	Philippe =?iso-8859-1?Q?Mathieu-Daud=E9?= <philmd@linaro.org>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Fuad Tabba <tabba@google.com>, kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	Oliver Upton <oliver.upton@linux.dev>,
	Sean Christopherson <seanjc@google.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Chao Peng <chao.p.peng@linux.intel.com>
Subject: Re: [PATCH v6 00/26] KVM: arm64: Introduce pKVM hyp VM and vCPU
 state at EL2
Message-ID: <20221114193027.GA31791@willie-the-truck>
References: <20221110190259.26861-1-will@kernel.org>
 <166819337067.3836113.13147674500457473286.b4-ty@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <166819337067.3836113.13147674500457473286.b4-ty@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)

On Fri, Nov 11, 2022 at 07:06:14PM +0000, Marc Zyngier wrote:
> On Thu, 10 Nov 2022 19:02:33 +0000, Will Deacon wrote:
> > This is version six of the pKVM EL2 state series, extending the pKVM
> > hypervisor code so that it can dynamically instantiate and manage VM
> > data structures without the host being able to access them directly.
> > These structures consist of a hyp VM, a set of hyp vCPUs and the stage-2
> > page-table for the MMU. The pages used to hold the hypervisor structures
> > are returned to the host when the VM is destroyed.
> > 
> > [...]
> 
> As for Oliver's series, I've tentatively applied this to -next.
> I've dropped Oliver's patch for now, but kept the RFC one. Maybe I'll
> change my mind.
> 
> Anyway, there was an interesting number of conflicts between the two
> series, which I tried to resolve as well as I could, but it is likely
> I broke something (although it compiles, so it must be perfect).
> 
> Please have a look and shout if/when you spot something.

Cheers, the resolution looks good to me and I've played around booting
non-protected guests under pKVM without any issues so far.

Will
