From: "Michael S. Tsirkin" <mst@redhat.com>
Subject: Re: [PATCH] vhost: Fix vhost_copy_to_user()
Date: Wed, 11 Apr 2018 16:51:32 +0300
Message-ID: <20180411165116-mutt-send-email-mst@kernel.org>
References: <1523453438-4266-1-git-send-email-eric.auger@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <virtualization-bounces@lists.linux-foundation.org>
Content-Disposition: inline
In-Reply-To: <1523453438-4266-1-git-send-email-eric.auger@redhat.com>
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/virtualization>,
	<mailto:virtualization-request@lists.linux-foundation.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/virtualization/>
List-Post: <mailto:virtualization@lists.linux-foundation.org>
List-Help: <mailto:virtualization-request@lists.linux-foundation.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/virtualization>,
	<mailto:virtualization-request@lists.linux-foundation.org?subject=subscribe>
Sender: virtualization-bounces@lists.linux-foundation.org
Errors-To: virtualization-bounces@lists.linux-foundation.org
To: Eric Auger <eric.auger@redhat.com>
Cc: kvm@vger.kernel.org, netdev@vger.kernel.org, linux-kernel@vger.kernel.org, virtualization@lists.linux-foundation.org, stefanha@redhat.com, kvmarm@lists.cs.columbia.edu, eric.auger.pro@gmail.com
List-Id: kvmarm@lists.cs.columbia.edu

On Wed, Apr 11, 2018 at 03:30:38PM +0200, Eric Auger wrote:
> vhost_copy_to_user is used to copy vring used elements to userspace.
> We should use VHOST_ADDR_USED instead of VHOST_ADDR_DESC.
> 
> Fixes: f88949138058 ("vhost: introduce O(1) vq metadata cache")
> Signed-off-by: Eric Auger <eric.auger@redhat.com>

Acked-by: Michael S. Tsirkin <mst@redhat.com>

> ---
> 
> This fixes a stall observed when running an aarch64 guest with
> virtual smmu
> ---
>  drivers/vhost/vhost.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
> index bec722e..f44aead 100644
> --- a/drivers/vhost/vhost.c
> +++ b/drivers/vhost/vhost.c
> @@ -744,7 +744,7 @@ static int vhost_copy_to_user(struct vhost_virtqueue *vq, void __user *to,
>  		struct iov_iter t;
>  		void __user *uaddr = vhost_vq_meta_fetch(vq,
>  				     (u64)(uintptr_t)to, size,
> -				     VHOST_ADDR_DESC);
> +				     VHOST_ADDR_USED);
>  
>  		if (uaddr)
>  			return __copy_to_user(uaddr, from, size);
> -- 
> 2.5.5
