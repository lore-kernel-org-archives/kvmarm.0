Received: from mail-pz2-f12.google.com (mail-pz2-f12.google.com [74.125.228.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CEFB53D9699
	for <kvmarm@lists.linux.dev>; Wed, 23 Sep 2026 18:30:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.228.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790188259; cv=none; b=ZDJiurhoGLWw3+1FvvlqHxP0y8f71Euev91B1VSnZb3NtBDPRiBQG/d2nmJJSdDvvJzXI8Xg67c3O59lEyCDK758fi1dCxbQ6JFuUZofE1DnSxQNXcqDlYenDRrnlAt+PT1n0O2Wi5gdXzmwXD3yYKE7WhEUds070oV8dsGc7tA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790188259; c=relaxed/simple;
	bh=lWag3oM9sYGpdHyGnDE7rA3iXeVqrktsZhX6pT4UGs4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=WbnlQ5xEl6IchC6SU2dKekpti+VvTMWLYAI+cauk6l0oXRE9lNceidKbpIB9QaEM8DIIUoNjVvaeJlb3En0DPUXxVyuluU3RY3qNon0R3UsCmeerTPuHb76SmhyydPnDSHen20cVX2Vd4D9B9ecZZo6vpIylZVid6+y6TrlO6Uw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=AF6yOIAv; arc=none smtp.client-ip=74.125.228.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="AF6yOIAv"
Received: by mail-pz2-f12.google.com with SMTP id 41be03b00d2f7-cc1ceb47d55so288018a12.1
        for <kvmarm@lists.linux.dev>; Wed, 23 Sep 2026 11:30:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1790188252; x=1790793052; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=qQbES28pq+4+5SdsOxa0hPCoAfkWzPeIh6+fD64KIF8=;
        b=AF6yOIAvyXRSQF0F4g+548lS//aE8Vy40b7Mt4CSlDKkyBaiOffOzXuwL+iR8+porO
         ka/uc0VA6bi1l0fKpN1lIddKBu7Pd5gntRL18rkq1/tFc2JGbkpa4WzH3/eRzgNw7jVk
         xy+kd8xEHIvMjVJzJq257BIb8AMD4EEe8luX03TZAWxlicdny98O6ltQ+hgaxob6luQr
         llb80QY15dkb43IgCOPOWOjqaLJW6QtV7am5+9JX6o1s2bBQVLLhN+BvwLIwd8tSXXEA
         NrLYi1DFP0oFPUY9STywzAuAJxLNkGyZAIsQmTvvcQgKO3ZtPOaUcQ59x1E8ZPJbLIgR
         kVMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790188252; x=1790793052;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=qQbES28pq+4+5SdsOxa0hPCoAfkWzPeIh6+fD64KIF8=;
        b=RgbhIcbRfm3HkbFl6ViimZUVvSFD53SYsy9zu4EL+hfbm05Mj5j6JE+0Pq0bx64iNO
         a0fn6oKoY04sRXirrACfsygbDCUZ0Urlk7fqUP+PlKrQNX0jguhHp5uZ6Fq+j00FVwVB
         ty65/LuTPIAja3D0rL8lU/swkG7TE3rcpQro1Q+ADY13xNnwbJ+44OmxtLgdrqtQ/Uin
         DGy4Q3F1lxKxDxj4tfb/9kZCxIsWrxL5KA7ejyAcIuUtbEipsGxLZEwIuHgd8JWPUrjV
         ClR3eJBbhahGR7gLb3gUBMGyvRzP7Fb8CPZ9O5tbGNULYMrXDvRTQeRTC/MG6ZjL3SWd
         HnCw==
X-Forwarded-Encrypted: i=1; AKwUvBw0vOhsdcjWiEbeVTv2c+WCwSbxwiZhEhpafsoIDKcSTS+6M7YpMBdGwGkGyeZO4QZytNpqY1w=@lists.linux.dev
X-Gm-Message-State: AFuF++kZs+zkoHclBvvQ0wMcDl8qYPdyC0ifLCKmfBV7uDVZdsLip1TP
	GJXoo3gQB1fjcvyDAOPL/nFMGrL3CHs6+LidFEYa/zjaPcujNDL+WN5mFgj2Pm771Q==
X-Gm-Gg: AYBFou0SEFOhkkmYrZ8UTjns/xjAoqa/6TDAQzieeXJNqEXKx+B9oI0vaR1sFP8PM7q
	rr1B2/6nKpfEcDNzNcDWXtNFBnvSn+yABLXai6HSTIr1Cy92Nz9ITdMO6maeEmLdhrQjeRFO5oP
	NrrtjQ3GAGy+adXyQqrvWyWqR8Hsk+vmPc0vpf2zwJEYZLdDSubhGjS7iakfUn5oHXIrzchW95u
	qCdckMhFvyOSer7Zyu6ZY84c/+RpGWgNqp0K0SX1k5We/FDjc0QlYlpLI1uxYspdau7CD8LIQfl
	5leDI9G1ctxxOFY6yQ8pXWGS0Cs67w/pbcq3kfUtGXobwZ/+CkhiQ370iyGCKNvv30n7NP/Llkr
	zuU40Tb43N+QzaK1dYY96yQsFu/MHrpZeoYVVRsCCrdy4qEc4nlTaw2asptcH51Ko1wcAaDisyY
	8AtlgGlL8Y/deVz34QrdcFu0DgDTKntON1ySrrD6FIJUmPyRSuCwADr1xkj3t1dPDIX0XRnFrge
	Og1MNSVUApDQTa+jMPwnE+d0lX9fQJQlZhZht5rJyA+YqkXefU=
X-Received: by 2002:a05:6a20:7290:b0:3db:131b:8d8 with SMTP id adf61e73a8af0-3de0e7300c0mr45910637.14.1790188251251;
        Wed, 23 Sep 2026 11:30:51 -0700 (PDT)
Received: from google.com (132.200.185.35.bc.googleusercontent.com. [35.185.200.132])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-87d1d5c12besm1736810b3a.29.2026.09.23.11.30.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Sep 2026 11:30:50 -0700 (PDT)
Date: Wed, 23 Sep 2026 18:30:46 +0000
From: David Matlack <dmatlack@google.com>
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: Alex Williamson <alex@shazbot.org>, Fuad Tabba <fuad.tabba@linux.dev>,
	Joey Gouly <joey.gouly@arm.com>, kvm@vger.kernel.org,
	kvmarm@lists.linux.dev, Leon Romanovsky <leon@kernel.org>,
	linux-arm-kernel@lists.infradead.org,
	linux-kselftest@vger.kernel.org, linux-rdma@vger.kernel.org,
	Marc Zyngier <maz@kernel.org>, Mark Bloch <mbloch@nvidia.com>,
	netdev@vger.kernel.org, Oliver Upton <oupton@kernel.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Saeed Mahameed <saeedm@nvidia.com>,
	Sean Christopherson <seanjc@google.com>,
	Steffen Eiden <seiden@linux.ibm.com>, Shuah Khan <shuah@kernel.org>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Tariq Toukan <tariqt@nvidia.com>, Zenghui Yu <yuzenghui@huawei.com>,
	patches@lists.linux.dev
Subject: Re: [PATCH v7 00/10] mlx5 support for VFIO self test
Message-ID: <arQa1khEHzKOfkCK@google.com>
References: <0-v7-c6d30e8ce1e4+3dfa6-mlx5st_jgg@nvidia.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0-v7-c6d30e8ce1e4+3dfa6-mlx5st_jgg@nvidia.com>

On 2026-09-21 07:35 PM, Jason Gunthorpe wrote:
> Add an mlx5 driver to VFIO self test. This is largely a remix of the
> existing VFIO mlx5 driver in rdma-core. It uses an RDMA loopback QP
> to issue RDMA WRITE operations which effectively perform memory
> copies using DMA. Since mlx5 has a stable programming ABI this
> should work on devices from CX5 to current HW. The device FW must
> support the QP loopback configuration.

> v7:
>  - Fix some compilation problems, kvm and the igb

> Jason Gunthorpe (10):
>   net/mlx5: Add IFC structures for CQE and WQE
>   net/mlx5: Move HW constant groups from device.h/cq.h to mlx5_ifc.h
>   net/mlx5: Extract MLX5_SET/GET macros into mlx5_ifc_macros.h
>   net/mlx5: Add ONCE and MMIO accessor variants to mlx5_ifc_macros.h
>   selftests: Add additional kernel functions to tools/include/
>   vfio: selftests: Allow drivers to specify required region size
>   vfio: selftests: Add dev_dbg
>   vfio: selftests: Add mlx5 driver - HW init and command interface
>   vfio: selftests: Add mlx5 driver - data path and memcpy ops
>   vfio: selftests: mlx5 driver - add send_msi support

>  .../selftests/kvm/include/arm64/processor.h   |    4 +-
>  tools/testing/selftests/kvm/irq_test.c        |    2 -

Sean and Marc/Oliver, can you take a look at the changes Jason made to
KVM selftests as part of this series before we merge this into the VFIO
tree?
