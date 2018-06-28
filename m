From: Peter Maydell <peter.maydell@linaro.org>
Subject: Re: [PATCH v2 0/5] Add virtio-iommu driver
Date: Thu, 28 Jun 2018 10:40:24 +0100
Message-ID: <CAFEAcA-h9qCgtcAjfF_=2G9NJVsA2_yfncCqWnp6q6bLPW7TvA@mail.gmail.com>
References: <20180621190655.56391-1-jean-philippe.brucker@arm.com>
	<20180626210132-mutt-send-email-mst@kernel.org>
	<2bcda195-d2c6-fbf0-322e-d91756fc3547@arm.com>
	<20180627224801-mutt-send-email-mst@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <virtualization-bounces@lists.linux-foundation.org>
In-Reply-To: <20180627224801-mutt-send-email-mst@kernel.org>
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/virtualization>,
	<mailto:virtualization-request@lists.linux-foundation.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/virtualization/>
List-Post: <mailto:virtualization@lists.linux-foundation.org>
List-Help: <mailto:virtualization-request@lists.linux-foundation.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/virtualization>,
	<mailto:virtualization-request@lists.linux-foundation.org?subject=subscribe>
Sender: virtualization-bounces@lists.linux-foundation.org
Errors-To: virtualization-bounces@lists.linux-foundation.org
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>, "jayachandran.nair@cavium.com" <jayachandran.nair@cavium.com>, Lorenzo Pieralisi <Lorenzo.Pieralisi@arm.com>, "tnowicki@caviumnetworks.com" <tnowicki@caviumnetworks.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "virtio-dev@lists.oasis-open.org" <virtio-dev@lists.oasis-open.org>, Will Deacon <Will.Deacon@arm.com>, "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>, "virtualization@lists.linux-foundation.org" <virtualization@lists.linux-foundation.org>, Marc Zyngier <Marc.Zyngier@arm.com>, "robh+dt@kernel.org" <robh+dt@kernel.org>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, Robin Murphy <Robin.Murphy@arm.com>, "joro@8bytes.org" <joro@8bytes.org>
List-Id: kvmarm@lists.cs.columbia.edu

On 27 June 2018 at 20:59, Michael S. Tsirkin <mst@redhat.com> wrote:
> My point was virtio mmio isn't widely used outside of ARM.
> Rather than try to make everyone use it, IMHO it's better
> to start with PCI.

Yes. I would much rather we let virtio-mmio disappear into
history as a random bit of legacy stuff. One of the things
I didn't like about the virtio-iommu design was that it
resurrected virtio-mmio as something we need to actively care
about again, so if there is a path forward that will work with
pci virtio I would much prefer that.

thanks
-- PMM
