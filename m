Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B483733082;
	Fri, 24 Nov 2023 16:00:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OHBEux1o"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC6B7C433CA;
	Fri, 24 Nov 2023 16:00:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700841615;
	bh=x4/TLLmjsrOuHHCNtA+3OOqTerComhNMyZEiZV7mtis=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=OHBEux1o1xTQtDic6Xsepye/fbD416/qXbpaILLpW4ggSsLinGpmMEL+9bkik3GiB
	 shSD9tC1YA/2mQ8O3Edw2yROM7xRv+/X0T/9o9PS76jrvIHskGqEUP6N2e0Ik1WKVr
	 3mIwQzmHbJwraA/7gFQJYsrdlXasqv9eRPOYLXJ4=
Date: Fri, 24 Nov 2023 16:00:12 +0000
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Kunkun Jiang <jiangkunkun@huawei.com>
Cc: Sasha Levin <sashal@kernel.org>, stable@vger.kernel.org,
	Dongli Zhang <dongli.zhang@oracle.com>, kvmarm@lists.linux.dev,
	wanghaibin.wang@huawei.com, yuzenghui@huawei.com
Subject: Re: [stable-4.19 PATCH] scsi: virtio_scsi: limit number of hw queues
 by nr_cpu_ids
Message-ID: <2023112405-factual-uncut-ba77@gregkh>
References: <20231109142328.1460-1-jiangkunkun@huawei.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231109142328.1460-1-jiangkunkun@huawei.com>

On Thu, Nov 09, 2023 at 10:23:28PM +0800, Kunkun Jiang wrote:
> From: Dongli Zhang <dongli.zhang@oracle.com>
> 
> [ Upstream commit 1978f30a87732d4d9072a20abeded9fe17884f1b ]
> 
> When tag_set->nr_maps is 1, the block layer limits the number of hw queues
> by nr_cpu_ids. No matter how many hw queues are used by virtio-scsi, as it
> has (tag_set->nr_maps == 1), it can use at most nr_cpu_ids hw queues.
> 
> In addition, specifically for pci scenario, when the 'num_queues' specified
> by qemu is more than maxcpus, virtio-scsi would not be able to allocate
> more than maxcpus vectors in order to have a vector for each queue. As a
> result, it falls back into MSI-X with one vector for config and one shared
> for queues.
> 
> Considering above reasons, this patch limits the number of hw queues used
> by virtio-scsi by nr_cpu_ids.
> 
> Reviewed-by: Stefan Hajnoczi <stefanha@redhat.com>
> Signed-off-by: Dongli Zhang <dongli.zhang@oracle.com>
> Signed-off-by: Jens Axboe <axboe@kernel.dk>
> Signed-off-by: Kunkun Jiang <jiangkunkun@huawei.com>
> ---
>  drivers/scsi/virtio_scsi.c | 1 +
>  1 file changed, 1 insertion(+)

Both now queued up, thanks.

greg k-h
