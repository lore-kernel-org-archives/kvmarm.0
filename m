From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH v3 02/11] KVM: arm: rename pm_fake handler to trap_raz_wi
Date: Tue, 30 Jun 2015 15:20:04 +0200
Message-ID: <20150630132004.GS11332@cbox>
References: <1434969694-7432-1-git-send-email-zhichao.huang@linaro.org>
 <1434969694-7432-3-git-send-email-zhichao.huang@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1434969694-7432-3-git-send-email-zhichao.huang@linaro.org>
Sender: kvm-owner@vger.kernel.org
To: Zhichao Huang <zhichao.huang@linaro.org>
Cc: kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, marc.zyngier@arm.com, alex.bennee@linaro.org, will.deacon@arm.com, huangzhichao@huawei.com
List-Id: kvmarm@lists.cs.columbia.edu

On Mon, Jun 22, 2015 at 06:41:25PM +0800, Zhichao Huang wrote:
> pm_fake doesn't quite describe what the handler does (ignoring writes
> and returning 0 for reads).
> 
> As we're about to use it (a lot) in a different context, rename it
> with a (admitedly cryptic) name that make sense for all users.
> 
> Signed-off-by: Zhichao Huang <zhichao.huang@linaro.org>
> Reviewed-by: Alex Bennee <alex.bennee@linaro.org>

Acked-by: Christoffer Dall <christoffer.dall@linaro.org>
