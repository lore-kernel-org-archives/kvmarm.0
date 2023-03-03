Received: from out-33.mta1.migadu.com (out-33.mta1.migadu.com [95.215.58.33])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E566538C
	for <kvmarm@lists.linux.dev>; Fri,  3 Mar 2023 12:08:06 +0000 (UTC)
Date: Fri, 3 Mar 2023 13:08:00 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1677845283;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=MFvIFOj655htJb0T58EwR5SPuf4Kw8SDISa3u05xsAw=;
	b=lq3eAZqtOX8y1ppEtSrQbQ0RAcPAnrYhNK6RJB0/Sxg54a8WgtmPk0Rfu3EZdbJwDtw9oX
	EVtXQgtsIA0IBl8zdUEqIT+/hnCqx3dFAEEIyDuLscf98gHokKXBXzUvCWZ4NPxjr38RXx
	ux50WsG3ESbNWc3IvyGxaPNX/DQ+7i8=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Andrew Jones <andrew.jones@linux.dev>
To: Jean-Philippe Brucker <jpb@kernel.org>
Cc: Suzuki K Poulose <suzuki.poulose@arm.com>,
	Jean-Philippe Brucker <jean-philippe@linaro.org>,
	Itaru Kitayama <itaru.kitayama@gmail.com>,
	linux-coco@lists.linux.dev, linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org, kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Chao Peng <chao.p.peng@linux.intel.com>,
	Christoffer Dall <christoffer.dall@arm.com>,
	Fuad Tabba <tabba@google.com>, James Morse <james.morse@arm.com>,
	Joey Gouly <Joey.Gouly@arm.com>, Marc Zyngier <maz@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Quentin Perret <qperret@google.com>,
	Sean Christopherson <seanjc@google.com>,
	Steven Price <steven.price@arm.com>, Thomas Huth <thuth@redhat.com>,
	Will Deacon <will@kernel.org>, Zenghui Yu <yuzenghui@huawei.com>,
	kvmarm@lists.cs.columbia.edu
Subject: Re: [RFC] Support for Arm CCA VMs on Linux
Message-ID: <20230303120800.ahtyc6et77ig4s27@orel>
References: <20230127112248.136810-1-suzuki.poulose@arm.com>
 <Y9PtKJ3Wicc19JF1@myrica>
 <CANW9uyud8RTkqgiL=64wV712QMxtAyubqeyCJ0vpcADJ42VqJA@mail.gmail.com>
 <Y/8Y3WLmiw6+Z5AS@myrica>
 <CANW9uysnvGCwANu+_6dp9+3rvHGOkThT9d0K2qpQV4exdmYWoA@mail.gmail.com>
 <20230303094618.GC361458@myrica>
 <1c91b777-982e-e71a-4829-51744e9555c5@arm.com>
 <20230303113905.GD361458@myrica>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230303113905.GD361458@myrica>
X-Migadu-Flow: FLOW_OUT

On Fri, Mar 03, 2023 at 11:39:05AM +0000, Jean-Philippe Brucker wrote:
> On Fri, Mar 03, 2023 at 09:54:47AM +0000, Suzuki K Poulose wrote:
> > On 03/03/2023 09:46, Jean-Philippe Brucker wrote:
> > > On Thu, Mar 02, 2023 at 07:12:24AM +0900, Itaru Kitayama wrote:
> > > > > > I've tried your series in Real on CCA Host, but the KVM arch init
> > > > > > emits an Invalid argument error and terminates.
> > > 
> > > This was the KVM_SET_ONE_REG for the SVE vector size. During my tests I
> > > didn't enable SVE in the host but shrinkwrap enables more options.
> > 
> > Does the Qemu check for SVE capability on /dev/kvm ? For kvmtool, we
> > changed to using the VM instance and that would prevent using SVE,
> > until the RMM supports it.
> 
> Yes, QEMU does check the SVE cap on /dev/kvm. I can propose changing it or
> complementing it with a VM check in my next version, it seems to work
> (though I need to double-check the VM fd lifetime). Same goes for
> KVM_CAP_STEAL_TIME, which I need to disable explicitly at the moment.

I'm probably missing something since I haven't looked at this, but I'm
wondering what the "VM instance" check is and why it should be necessary.
Shouldn't KVM only expose capabilities which it can provide? I.e. the
"VM instance" check should be done by KVM and, when it fails, the SVE and
steal-time capabilities should return 0.

Thanks,
drew
