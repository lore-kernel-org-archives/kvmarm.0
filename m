Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95E4C15B6
	for <kvmarm@lists.linux.dev>; Fri,  8 Sep 2023 16:41:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4839DC433C9;
	Fri,  8 Sep 2023 16:40:58 +0000 (UTC)
Date: Fri, 8 Sep 2023 17:40:55 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: ankita@nvidia.com
Cc: jgg@nvidia.com, maz@kernel.org, oliver.upton@linux.dev, will@kernel.org,
	aniketa@nvidia.com, cjia@nvidia.com, kwankhede@nvidia.com,
	targupta@nvidia.com, vsethi@nvidia.com, acurrid@nvidia.com,
	apopple@nvidia.com, jhubbard@nvidia.com, danw@nvidia.com,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	Lorenzo Pieralisi <lpieralisi@kernel.org>
Subject: Re: [PATCH v1 2/2] KVM: arm64: allow the VM to select DEVICE_* and
 NORMAL_NC for IO memory
Message-ID: <ZPtOl7EqLzMusuIX@arm.com>
References: <20230907181459.18145-1-ankita@nvidia.com>
 <20230907181459.18145-3-ankita@nvidia.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20230907181459.18145-3-ankita@nvidia.com>

+ Lorenzo

On Thu, Sep 07, 2023 at 11:14:59AM -0700, ankita@nvidia.com wrote:
> From: Ankit Agrawal <ankita@nvidia.com>
> 
> Linux allows device drivers to map IO memory on a per-page basis using
> "write combining" or WC. This is often done using
> pgprot_writecombing(). The driver knows which pages can support WC
> access and the proper programming model to generate this IO. Generally
> the use case is to boost performance by using write combining to
> generate larger PCIe MemWr TLPs.
> 
> Allow VMs to select DEVICE_* or NORMAL_NC on a page by page basis for
> all IO memory. This puts the VM in charge of the memory attributes,
> and removes the KVM override to DEVICE_nGnRE.
> 
> Ultimately this makes pgprot_writecombing() work correctly in VMs and
> allows drivers like mlx5 to fully operate their HW.
> 
> After some discussions with ARM and CPU architects we reached the
> conclusion there was no need for KVM to prevent the VM from selecting
> between DEVICE_* and NORMAL_NC for IO memory in VMs. There was a fear
> that NORMAL_NC could result in uncontained failures, but upon deeper
> analysis it turns out there are already possible cases for uncontained
> failures with DEVICE types too. Ultimately the platform must be
> implemented in a way that ensures that all DEVICE_* and NORMAL_NC
> accesses have no uncontained failures.
> 
> Fortunately real platforms do tend to implement this.
> 
> This patch makes the VM's memory attributes behave as follows:
> 
>  S1           |   S2          |  Result
>  NORMAL-WB    |  NORMAL-NC    |  NORMAL-NC
>  NORMAL-WT    |  NORMAL-NC    |  NORMAL-NC
>  NORMAL-NC    |  NORMAL-NC    |  NORMAL-NC
>  DEVICE<attr> |  NORMAL-NC    |  DEVICE<attr>
> 
> See section D8.5.5 of DDI0487_I_a_a-profile_architecture_reference_manual.pdf
> for details.
> 
> Signed-off-by: Ankit Agrawal <ankita@nvidia.com>

From the discussions with the hardware people in Arm and Nvidia, we
indeed concluded that relaxing S2 to Normal-NC is not any worse than
Device (and actually Device memory is more prone to generating
uncontained errors, something to do with the Device memory ordering
semantics).

For this change:

Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>

-- 
Catalin
